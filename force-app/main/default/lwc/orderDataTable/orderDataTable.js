/**
 * Created by Frederik on 14/12/2022.
 */

import {LightningElement, api, wire, track} from 'lwc';
import getOrderData from '@salesforce/apex/B2BOrderTable.getOrders';
import setToken from '@salesforce/apex/B2BOrderTable.setToken';
import getOrderLinesToExport from '@salesforce/apex/B2BOrderTable.getOrderLinesToExport';
import reOrderCart from '@salesforce/apex/B2BOrderTable.reOrderCart';
import basePath from '@salesforce/community/basePath';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import cartChanged from "@salesforce/messageChannel/lightning__commerce_cartChanged";
import {
    publish,
    MessageContext
} from "lightning/messageService";
export default class OrderDataTable extends LightningElement {

    @wire(MessageContext)
    messageContext;

    @api recordId;
    @api effectiveAccountId;
    orderId = '';
    allOrderLines = [];
    @track orderLines = [];
    showOrderTable = true;
    showOrderLinesTable = false;

    @track startDate;
    @track endDate;

    fileHeader = ['Order Start Date', 'Supplier Order Nbr', 'Quantity', 'Brand', 'Description', 'Unit Price', 'Total Price', 'Comment', 'Supplier'];

    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';
    variantOptions = [
        { label: 'error', value: 'error' },
        { label: 'warning', value: 'warning' },
        { label: 'success', value: 'success' },
        { label: 'info', value: 'info' },
    ];

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }

    openInvoice(event) {
        console.log(event.target.dataset.url);
        console.log('openInvoice', event.target.value);
        let url = event.target.value;
        window.open(url, '_blank', 'popup=yes,scrollbars=yes,resizable=yes,top=500,left=500,width=800,height=800');
    }



    connectedCallback() {
        setToken({});
        console.log('recordId', this.recordId);
        console.log('effectiveAccountId', this.effectiveAccountId);
        console.log('basePath', basePath);
        getOrderData({effectiveAccountId: this.effectiveAccountId})
            .then(result => {
                let orders = [];
                result.forEach(order => {
                    console.log('order ' +JSON.stringify(order));
                    let orderLine = {
                        id: order.Id,
                        orderNumber: order.OrderNumber,
                        orderDetail: basePath + '/order/' + order.Id +'/detail',
                        accountName: order.Account.Name,
                        supplierName: order.Supplier__r.Name,
                        totalAmount: order.TotalAmount,
                        orderDate: order.EffectiveDate,
                        orderInvoice: order.Invoice__c,
                        orderOrderUrl: order.Order_PDF__c,
                        hasInvoice: order.Invoice__c != null && order.Invoice__c != '' ? true : false,
                        hasOrder: order.Order_PDF__c != null && order.Order_PDF__c != '' ? true : false
                    }
                    orders.push(orderLine);
                });
                this.orderLines = orders;
                this.allOrderLines = orders;
                console.log('orders', JSON.stringify(this.orders));
            })
            .catch(error => {
                console.log('error', error.message);
            });
    }

    @wire(getOrderData, {effectiveAccountId: '$effectiveAccountId'})
    orders;

    handleReorder(event) {
        console.log('handleReorder', event);
        console.log('handleReorder', event.target.value);
        reOrderCart({orderId: event.target.value})
            .then(result => {
                console.log('result', result);
                this._title = 'Success';
                this.message = 'The order has been re-added to your cart';
                this.variant = 'success';
                this.showNotification();
                publish(this.messageContext, cartChanged);
            })
            .catch(error => {
                console.log('error', error);
            });
    }

    handleItemReorder(event) {
        console.log('handleItemReorder', event);
        this.orderId = event.target.value;
        this.recordId = event.target.value;
        this.showOrderTable = false;
        this.showOrderLinesTable = true;
    }

    handleBackToOrders(event) {
        console.log('handleBackToOrders', event);
        this.showOrderTable = true;
        this.showOrderLinesTable = false;
    }

    exportOrdersExcel() {
        var items = this.template.querySelectorAll('.ordercheckbox'); 
        var ordernumbers = ''; 
        for (var i = 0; i < items.length; i++) {
            if(items[i].checked == true){
                ordernumbers = ordernumbers + String(items[i].getAttribute('data-ordernumber')) + ';';
            }
        }
        getOrderLinesToExport({ordernumbers: ordernumbers})
            .then(result => {
                let doc = '<table>';
                doc += '<style>';
                doc += 'table, th, td {';
                doc += '    border: 1px solid black;';
                doc += '    border-collapse: collapse;';
                doc += '}';          
                doc += '</style>';
                doc += '<tr>';
                this.fileHeader.forEach(element => {            
                    doc += '<th>'+ element +'</th>'           
                });
                doc += '</tr>';
                result.forEach(record => {
                    doc += '<tr>';
                    doc += '<th>'+'&nbsp;'+(record.Order.EffectiveDate === undefined ? '' : record.Order.EffectiveDate)+'</th>'; 
                    doc += '<th>'+'&nbsp;'+(record.Order.Supplier_Order_Nbr__c === undefined ? '' : record.Order.Supplier_Order_Nbr__c)+'</th>';
                    doc += '<th>'+'&nbsp;'+(record.Quantity === undefined ? '' : record.Quantity)+'</th>';  
                    doc += '<th>'+'&nbsp;'+(record.Product2.Parent__r.Brand__r.Description_FR__c === undefined ? '' : record.Product2.Parent__r.Brand__r.Description_FR__c)+'</th>';
                    doc += '<th>'+'&nbsp;'+(record.Product2.Parent__r.Description_FR__c === undefined ? '' : record.Product2.Parent__r.Description_FR__c)+'</th>';
                    doc += '<th>'+'&nbsp;'+(record.UnitPrice === undefined ? '' : record.UnitPrice)+'</th>';
                    doc += '<th>'+'&nbsp;'+(record.TotalPrice === undefined ? '' : record.TotalPrice)+'</th>';
                    doc += '<th>'+'&nbsp;'+(record.Description === undefined ? '' : record.Description)+'</th>';
                    doc += '<th>'+'&nbsp;'+(record.Order.Supplier__r.Name === undefined ? '' : record.Order.Supplier__r.Name)+'</th>';
                    doc += '</tr>';
                });
                doc += '</table>';
                var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
                let downloadElement = document.createElement('a');
                downloadElement.href = element;
                downloadElement.target = '_self';
                downloadElement.download = 'Orders.xls';
                document.body.appendChild(downloadElement);
                downloadElement.click();
            })
            .catch(error => {
                console.log('getOrderLinesToExport error', error);
            });
    }

    exportOrdersCsv() {
        var items = this.template.querySelectorAll('.ordercheckbox'); 
        var ordernumbers = ''; 
        for (var i = 0; i < items.length; i++) {
            if(items[i].checked == true){
                ordernumbers = ordernumbers + String(items[i].getAttribute('data-ordernumber')) + ';';
            }
        }
        getOrderLinesToExport({ordernumbers: ordernumbers})
            .then(result => {
                let rowEnd = '\n';
                let csvString = '';
                let rowHead = new Set();
                rowHead.add('Order Start Date');
                rowHead.add('Supplier Order Nbr');
                rowHead.add('Quantity');
                rowHead.add('Brand');
                rowHead.add('Description');  
                rowHead.add('Unit Price');  
                rowHead.add('Total Price');  
                rowHead.add('Comment');  
                rowHead.add('Supplier');  
                rowHead = Array.from(rowHead);

                csvString += rowHead.join(',');
                csvString += rowEnd;
        
                for(let i=0; i < result.length; i++){
                    csvString += (result[i].Order.EffectiveDate === undefined ? '' : result[i].Order.EffectiveDate) +',' + (result[i].Order.Supplier_Order_Nbr__c === undefined ? '' : result[i].Order.Supplier_Order_Nbr__c) +',' + (result[i].Quantity === undefined ? '' : result[i].Quantity) + ','+ (result[i].Product2.Parent__r.Brand__r.Description_FR__c === undefined ? '' : result[i].Product2.Parent__r.Brand__r.Description_FR__c) +','+ (result[i].Product2.Parent__r.Description_FR__c === undefined ? '' : result[i].Product2.Parent__r.Description_FR__c) + ',' + (result[i].UnitPrice === undefined ? '' : result[i].UnitPrice) + ',' + (result[i].TotalPrice === undefined ? '' : result[i].TotalPrice) + ',' + (result[i].Description === undefined ? '' : result[i].Description) + ',' + (result[i].Order.Supplier__r.Name  === undefined ? '' : result[i].Order.Supplier__r.Name ); 
                    csvString += rowEnd;
                }
        
                let downloadElement = document.createElement('a');
                downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
                downloadElement.target = '_self';
                downloadElement.download = 'Orders.csv';
                document.body.appendChild(downloadElement);
                downloadElement.click(); 
            })
            .catch(error => {
                console.log('getOrderLinesToExport error', error);
            });
    }

    handleStartDateChange(event){
        this.startDate = event.target.value;
    }

    handleEndDateChange(event){
        this.endDate = event.target.value;
    }

    filterByDate(){
        var items = this.template.querySelectorAll('.ordercheckbox'); 
        for (var i = 0; i < items.length; i++) {
            items[i].checked = false;
        }

        var orders = this.allOrderLines;
        var tempOrders = [];
        if(this.startDate && this.endDate){
            orders.forEach(order => {
                if((order.orderDate >= this.startDate) && (this.endDate >= order.orderDate)){
                    tempOrders.push(order);
                }
            });
        } else if(this.startDate){
            orders.forEach(order => {
                if(order.orderDate >= this.startDate){
                    tempOrders.push(order);
                }
            });
        } else if(this.endDate){
            orders.forEach(order => {
                if(this.endDate >= order.orderDate){
                    tempOrders.push(order);
                }
            });
        } else{
            tempOrders = this.allOrderLines;
        }
        this.orderLines = tempOrders;
    }

    rsetFilterByDate(){
        var items = this.template.querySelectorAll('.ordercheckbox'); 
        for (var i = 0; i < items.length; i++) {
            items[i].checked = false;
        }

        this.orderLines = this.allOrderLines;
    }
    
}