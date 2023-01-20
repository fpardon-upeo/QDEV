/**
 * Created by Chris on 06/01/2023.
 */

import {LightningElement, api, wire, track} from 'lwc';
import getOrderLines from '@salesforce/apex/B2BOrderTable.getOrderLines';
import reOrderCartItem from '@salesforce/apex/B2BOrderTable.reOrderCartItem';
import basePath from '@salesforce/community/basePath';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import cartChanged from "@salesforce/messageChannel/lightning__commerce_cartChanged";
import {
    publish,
    MessageContext
} from "lightning/messageService";
export default class TestOrderProductDataTable extends LightningElement {

    @wire(MessageContext)
    messageContext;

    @api recordId;
    @api orderId;
    @api effectiveAccountId;
    orderLines = [];

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



    connectedCallback() {
        console.log('recordId', this.recordId);
        console.log('effectiveAccountId', this.effectiveAccountId);
        console.log('basePath', basePath);
        getOrderLines({orderId: this.recordId})
            .then(result => {
                console.log('result', result);
                let orderLines = [];
                result.forEach(order => {
                    let orderLine = {
                        id: order.Id,
                        productName: order.Product2.Name,
                        productNameDetail: basePath + '/detail/' + order.Id,
                        productEAN: order.Product2.Parent__r.EAN_Code__c,
                        quantity: order.Quantity,
                        unitPrice: order.UnitPrice/*,
                        supplier: Supplier_Ext__c,
                        productBrand: Brand_Ext__c,
                        LineItemDescription: Description,
                        EstimatedDeliveryDate: Estimated_Delivery_Date__c*/
                    }
                    orderLines.push(orderLine);
                });
                this.orderLines = orderLines;
                console.log('orders', JSON.stringify(this.orderLines));
            })
            .catch(error => {
                console.log('error', error);
            });
    }


    handleReorder(event) {
        console.log('handleReorder', event);
        reOrderCartItem({orderItemId: event.target.value})
            .then(result => {
                console.log('result', result);
                this._title = 'Success';
                this.message = 'The product has been re-added to your cart';
                this.variant = 'success';
                this.showNotification();
                publish(this.messageContext, cartChanged);
            })
            .catch(error => {
                console.log('error', error);
            });
    }

    handleClose(event) {
        console.log('handleClose', event);
        this.dispatchEvent(new CustomEvent('close'));
    }

}