/**
 * Created by Frederik on 13/12/2022.
 */

import {LightningElement, wire, track} from 'lwc';
import getSuppliers from '@salesforce/apex/WebCareSyncHandler.getSuppliers';
import getProfiles from '@salesforce/apex/WebCareSyncHandler.getProfiles';
import getArticles from '@salesforce/apex/WebCareSyncHandler.getArticles';
import getTransportCosts from '@salesforce/apex/WebCareSyncHandler.getTransportCosts';
import getBrands from '@salesforce/apex/WebCareSyncHandler.getBrands';
import getCustomers from '@salesforce/apex/WebCareSyncHandler.getCustomers';
import getArticlePrices from '@salesforce/apex/WebCareSyncHandler.getArticlePrices';
import getArticleBatchJob from '@salesforce/apex/WebCareSyncHandler.getArticleBatchJob';
import getArticlePricesBatchJob from '@salesforce/apex/WebCareSyncHandler.getArticlePricesBatchJob';
import monitorJob from '@salesforce/apex/WebCareSyncHandler.monitorJob';

export default class WebcareSync extends LightningElement {

    @track supplierJobId;
    @track profileJobId;
    @track articleJobId;
    @track articlePricesJobId;
    @track transportCostJobId;
    @track brandJobId;
    @track customerJobId;

    @track supplierJobProcessing = false;
    @track profileJobProcessing = false;
    @track articleJobProcessing = false;
    @track articlePricesJobProcessing = false;
    @track transportJobProcessing = false;
    @track brandJobProcessing = false;
    @track customerJobProcessing = false;


    supplierJobCompleted = false;
    profileJobCompleted = false;
    articleJobCompleted = false;
    articlePricesJobCompleted = false;
    transportJobCompleted = false;
    brandJobCompleted = false;
    customerJobCompleted = false;


    @track articleJobStatus;
    @track articlePricesJobStatus;

    articleJobItemsProcessed = 0;
    articleJobItemsTotal = 0;
    articlePricesJobItemsProcessed = 0;
    articlePricesJobItemsTotal = 0;



    connectedCallback() {

        getArticleBatchJob()
            .then(result => {
                if(result.length !== null) {
                    this.articleJobId = result.Id;
                    this.articleJobProcessing = true;
                    this.articleJobCompleted = false;
                    this.monitorJobArticle(this.articleJobId);
                }
            })
            .catch(error => {
                console.log('error: ' + JSON.stringify(error));
            })
        getArticlePricesBatchJob()
            .then(result => {
                if(result.length !== null) {
                    this.articlePricesJobId = result.Id;
                    this.articlePricesJobProcessing = true;
                    this.articlePricesJobCompleted = false;
                    this.monitorJobArticlePrices(this.articlePricesJobId);
                }
            })
            .catch(error => {
                console.log('error: ' + JSON.stringify(error));
            })
    }

    getWebCareTransportCosts() {
        console.log('getWebCareTransportCosts');
        this.transportJobCompleted = false;
        this.transportJobProcessing = true;
        getTransportCosts()
            .then(result => {
                this.transportCostJobId = result;
                console.log('transportCostJobId: ' + this.transportCostJobId);
                if(this.transportCostJobId !== null) {
                    this.transportJobCompleted = true;
                    this.transportJobProcessing = false;
                }
            })
    }

    getWebCareCustomers() {
        console.log('getWebCareTransportCosts');
        this.customerJobCompleted = false;
        this.customerJobProcessing = true;
        getCustomers()
            .then(result => {
                this.customerJobId = result;
                console.log('transportCostJobId: ' + this.customerJobId);
                if(this.customerJobId !== null) {
                    this.customerJobCompleted = true;
                    this.customerJobProcessing = false;
                }
            })
    }

    getWebCareSuppliers() {
        console.log('getWebCareSuppliers');
        getSuppliers()
            .then(result => {
                this.supplierJobId = result;
                this.supplierJobCompleted = false;
                this.supplierJobProcessing = true;
                this.monitorJobSupplier(this.supplierJobId);
            })
    }

    getWebCareProfiles() {
        console.log('getProfiles');
        getProfiles()
            .then(result => {
                this.profileJobId = result;
                this.profileJobProcessing = true;
                this.profileJobCompleted = false;
                this.monitorJobProfile(this.profileJobId);
            })
    }

    getWebCareBrands() {
        console.log('getBrands');
        getBrands()
            .then(result => {
                this.brandJobId = result;
                this.brandJobProcessing = true;
                this.brandJobCompleted = false;
                this.monitorJobBrand(this.brandJobId);
            })
    }

    getWebCareArticles() {
        console.log('getWebCareArticles');
        getArticles()
            .then(result => {
                console.log('getArticles result: ' + JSON.stringify(result));
                this.articleJobId = result;
                this.articleJobProcessing = true;
                this.articleJobCompleted = false;
                this.monitorJobArticle(this.articleJobId);
            })
    }

    getWebCareArticlePrices() {
        console.log('getWebCareArticlePrices');
        getArticlePrices()
            .then(result => {
                console.log('getArticlePrices result: ' + JSON.stringify(result));
                this.articlePricesJobId = result;
                this.articlePricesJobProcessing = true;
                this.articlePricesJobCompleted = false;
                this.monitorJobArticlePrices(this.articlePricesJobId);
            })
    }


    monitorJobArticle(jobId) {
        console.log('monitorJob');
        monitorJob({jobId: jobId})
            .then(result => {
                if (result.Status === 'Completed') {
                    this.articleJobItemsProcessed = result.JobItemsProcessed;
                    this.articleJobItemsTotal = result.TotalJobItems;
                    this.articleJobStatus = 'Checking for next batch';
                    setTimeout(() => {
                        this.checkForNextArticleBatch();
                    }, 5000);
                } else if (result.Status === 'Failed') {
                    this.articleJobCompleted = true;
                    this.articleJobProcessing = false;
                    this.articleJobStatus = result.Status;
                } else {
                    this.articleJobStatus = result.Status;
                    this.articleJobItemsProcessed = result.JobItemsProcessed;
                    this.articleJobItemsTotal = result.TotalJobItems;
                    setTimeout(() => {
                        this.monitorJobArticle(jobId);
                    }, 2000);
                }
            })
    }

    monitorJobArticlePrices(jobId) {
        console.log('monitorJob');
        monitorJob({jobId: jobId})
            .then(result => {
                if (result.Status === 'Completed') {
                    this.articlePricesJobItemsProcessed = result.JobItemsProcessed;
                    this.articlePricesJobItemsTotal = result.TotalJobItems;
                    this.articlePricesJobStatus = 'Checking for next batch';
                    setTimeout(() => {
                        this.checkForNextArticleBatch();
                    }, 5000);
                } else if (result.Status === 'Failed') {
                    this.articlePricesJobCompleted = true;
                    this.articlePricesJobProcessing = false;
                    this.articlePricesJobStatus = result.Status;
                } else {
                    this.articlePricesJobStatus = result.Status;
                    this.articlePricesJobItemsProcessed = result.JobItemsProcessed;
                    this.articlePricesJobItemsTotal = result.TotalJobItems;
                    setTimeout(() => {
                        this.monitorJobArticlePrices(jobId);
                    }, 2000);
                }
            })
    }

    monitorJobProfile(jobId) {
        console.log('monitorJob');
        monitorJob({jobId: jobId})
            .then(result => {
                console.log('monitorJob result: ' + JSON.stringify(result));
                if (result.Status === 'Completed') {
                    this.profileJobCompleted = true;
                    this.profileJobProcessing = false;
                } else {
                    setTimeout(() => {
                        this.monitorJobProfile(jobId);
                    }, 2000);
                }
            })
    }

    monitorJobBrand(jobId) {
        console.log('monitorJob Brand');
        monitorJob({jobId: jobId})
            .then(result => {
                console.log('monitorJob Brand result: ' + JSON.stringify(result));
                if (result.Status === 'Completed') {
                    this.brandJobCompleted = true;
                    this.brandJobProcessing = false;
                } else {
                    setTimeout(() => {
                        this.monitorJobBrand(jobId);
                    }, 2000);
                }
            })
    }

    monitorJobTransportCost(jobId) {
        console.log('monitorJob');
        monitorJob({jobId: jobId})
            .then(result => {
                console.log('monitorJob result: ' + JSON.stringify(result));
                if (result.Status === 'Completed') {
                    this.transportJobCompleted = true;
                    this.transportJobProcessing = false;
                } else {
                    setTimeout(() => {
                        this.monitorJobTransportCost(jobId);
                    }, 2000);
                }
            })
    }



    monitorJobSupplier(jobId) {
        console.log('monitorJob');
        monitorJob({jobId: jobId})
            .then(result => {
                console.log('monitorJob result: ' + JSON.stringify(result));
                if (result.Status === 'Completed') {
                    console.log('Job completed');
                    this.supplierJobProcessing = false;
                    this.supplierJobCompleted = true;
                } else {
                    console.log('Job not completed');
                    this.monitorJobSupplier(jobId);
                }
            })
    }

    checkForNextArticleBatch() {
        getArticleBatchJob()
            .then(result => {
                console.log('getArticleBatchJob result: ' + JSON.stringify(result));
                console.log('getArticleBatchJob result: ' +result.length);
                if(result.length !== null) {
                    this.articleJobId = result.Id;
                    this.articleJobProcessing = true;
                    this.articleJobCompleted = false;
                    this.monitorJobArticle(this.articleJobId);
                } else {
                    this.articleJobStatus = 'No more batches';
                    this.articleJobProcessing = false;
                    this.articleJobCompleted = true;
                }
            })
    }

    get articleProgress() {
        return (this.articleJobItemsProcessed/this.articleJobItemsTotal)*100;
    }

    get articlePricesProgress() {
        return (this.articlePricesJobItemsProcessed/this.articlePricesJobItemsTotal)*100;
    }

}