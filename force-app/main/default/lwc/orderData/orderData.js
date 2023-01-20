/**
 * Created by Frederik on 14/12/2022.
 */

import {LightningElement, api, wire, track} from 'lwc';
import getOrderData from '@salesforce/apex/B2BOrderTable.getOrderItems';
import setToken from '@salesforce/apex/B2BOrderTable.setToken';
import getOrderLinesToExport from '@salesforce/apex/B2BOrderTable.getOrderLinesToExport';
import reOrderCart from '@salesforce/apex/B2BOrderTable.reOrderCart';
import reOrderCartItem from '@salesforce/apex/B2BOrderTable.reOrderCartItem';
import basePath from '@salesforce/community/basePath';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import cartChanged from "@salesforce/messageChannel/lightning__commerce_cartChanged";
import B2BOrderTable_Order_Number from '@salesforce/label/c.B2BOrderTable_Order_Number';
import B2BOrderTable_Order_Date from '@salesforce/label/c.B2BOrderTable_Order_Date';
import B2BOrderTable_Supplier from '@salesforce/label/c.B2BOrderTable_Supplier';
import B2BOrderTable_Est_Del_Date from '@salesforce/label/c.B2BOrderTable_Est_Del_Date';
import B2BOrderTable_Brand from '@salesforce/label/c.B2BOrderTable_Brand';
import B2BOrderTable_Product from '@salesforce/label/c.B2BOrderTable_Product';
import B2BOrderTable_Comment from '@salesforce/label/c.B2BOrderTable_Comment';
import B2BOrderTable_Quantity from '@salesforce/label/c.B2BOrderTable_Quantity';
import B2BOrderTable_Price from '@salesforce/label/c.B2BOrderTable_Price';
import B2BOrderTable_Reorder from '@salesforce/label/c.B2BOrderTable_Reorder';
import B2BOrderTable_Filter_Start	 from '@salesforce/label/c.B2BOrderTable_Filter_Start';
import B2BOrderTable_Filter_End from '@salesforce/label/c.B2BOrderTable_Filter_End';
import B2BOrderTable_Filter_Apply from '@salesforce/label/c.B2BOrderTable_Filter_Apply';
import B2BOrderTable_Filter_Reset from '@salesforce/label/c.B2BOrderTable_Filter_Reset';
import B2BOrderTable_Filter_Text from '@salesforce/label/c.B2BOrderTable_Filter_Text';
import B2BOrderTable_Export_Title from '@salesforce/label/c.B2BOrderTable_Export_Title';


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
    selectAll = false;

    @track startDate;
    @track endDate;

    // Labels
    B2BOrderTable_Order_Number = B2BOrderTable_Order_Number;
    B2BOrderTable_Order_Date = B2BOrderTable_Order_Date;
    B2BOrderTable_Supplier = B2BOrderTable_Supplier;
    B2BOrderTable_Est_Del_Date = B2BOrderTable_Est_Del_Date;
    B2BOrderTable_Brand = B2BOrderTable_Brand;
    B2BOrderTable_Product = B2BOrderTable_Product;
    B2BOrderTable_Comment = B2BOrderTable_Comment;
    B2BOrderTable_Quantity = B2BOrderTable_Quantity;
    B2BOrderTable_Price = B2BOrderTable_Price;
    B2BOrderTable_Reorder = B2BOrderTable_Reorder;
    B2BOrderTable_Filter_Start = B2BOrderTable_Filter_Start;
    B2BOrderTable_Filter_End = B2BOrderTable_Filter_End;
    B2BOrderTable_Filter_Apply = B2BOrderTable_Filter_Apply;
    B2BOrderTable_Filter_Reset = B2BOrderTable_Filter_Reset;
    B2BOrderTable_Filter_Text = B2BOrderTable_Filter_Text;
    B2BOrderTable_Export_Title = B2BOrderTable_Export_Title;



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
        console.log('connectedCallback in new table');
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
                        orderId: order.Order.Id,
                        brand: order.Brand_Ext__c,
                        supplierLogo: order.Supplier_Ext__c,
                        description: order.Description,
                        orderNumber: order.Order.OrderNumber,
                        productDescription: order.Product_Description__c,
                        quantity: order.Quantity,
                        orderDetail: basePath + '/order/' + order.Order.Id +'/detail',
                        accountName: order.Order.Account.Name,
                        supplierName: order.Order.Supplier__r.Name,
                        totalAmount: order.UnitPrice,
                        orderDate: order.ServiceDate,
                        createdDate: order.Order.CreatedDate,
                        orderInvoice: order.Order.Invoice__c,
                        orderOrderUrl: order.Order.Order_PDF__c,
                        hasInvoice: order.Order.Invoice__c != null && order.Order.Invoice__c != '' ? true : false,
                        hasOrder: order.Order.Order_PDF__c != null && order.Order.Order_PDF__c != '' ? true : false
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
        reOrderCartItem({orderItemId: event.target.value})
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
                    doc += '<th>'+'&nbsp;'+(record.Product2.Parent__r.Brand__r.description_FR__c === undefined ? '' : record.Product2.Parent__r.Brand__r.description_FR__c)+'</th>';
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
            console.log('items[i].checked', items[i].checked);
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
                    csvString +=
                        (result[i].Order.EffectiveDate === undefined ? '' : result[i].Order.EffectiveDate)
                        +',' +
                        (result[i].Order.Supplier_Order_Nbr__c === undefined ? '' : result[i].Order.Supplier_Order_Nbr__c)
                        +',' +
                        (result[i].Quantity === undefined ? '' : result[i].Quantity)
                        + ','+
                        (result[i].Product2.Parent__r.Brand__r.description_FR__c === undefined ? '' : result[i].Product2.Parent__r.Brand__r.description_FR__c)
                        +','+
                        (result[i].Product2.Parent__r.Description_FR__c === undefined ? '' : result[i].Product2.Parent__r.Description_FR__c)
                        + ',' +
                        (result[i].UnitPrice === undefined ? '' : result[i].UnitPrice)
                        + ',' +
                        (result[i].TotalPrice === undefined ? '' : result[i].TotalPrice)
                        + ',' +
                        (result[i].Description === undefined ? '' : result[i].Description)
                        + ',' +
                        (result[i].Order.Supplier__r.Name  === undefined ? '' : result[i].Order.Supplier__r.Name );
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

    handleSelectAll(event) {
        this.selectAll = event.target.checked;
        var items = this.template.querySelectorAll('.ordercheckbox');
        for (var i = 0; i < items.length; i++) {
            items[i].checked = this.selectAll;
        }

    }

    handleStartDateChange(event){
        this.startDate = Date.parse(event.target.value);
        console.log('startDate', this.startDate);
    }

    handleEndDateChange(event){
        this.endDate = Date.parse(event.target.value);
        console.log('endDate', this.endDate);
    }

    filterByDate(){
        var items = this.template.querySelectorAll('.ordercheckbox'); 
        for (var i = 0; i < items.length; i++) {
            items[i].checked = false;
        }

        var orders = this.allOrderLines;
        var tempOrders = [];
        if(this.startDate && this.endDate){
            if(this.startDate == this.endDate){
                this.endDate = this.endDate + 86400000;
            }
            orders.forEach(order => {
                let orderDate = Date.parse(order.createdDate);
                console.log('order.createdDate', Date.parse(order.createdDate));
                if((orderDate>= this.startDate) && (this.endDate >= orderDate)){
                    console.log('order within range')
                    tempOrders.push(order);
                }
            });
        } else if(this.startDate){
            orders.forEach(order => {
                let orderDate = Date.parse(order.createdDate);
                if(orderDate >= this.startDate){
                    tempOrders.push(order);
                }
            });
        } else if(this.endDate){
            orders.forEach(order => {
                let orderDate = Date.parse(order.createdDate);
                if(this.endDate >= orderDate){
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