/**
 * Created by Frederik on 29/11/2022.
 */

import { api, wire, track, LightningElement } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
/**
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import cartSplitStyle from '@salesforce/resourceUrl/CartSplitStyle';
import getWebCareTotalItems from '@salesforce/apex/WebCareCartServiceBtoB.getWebCareTotalItems';
import getWebCareCartItems from '@salesforce/apex/WebCareCartServiceBtoB.getWebCareCartItems';
import getContactPointAddresses from '@salesforce/apex/WebCareCartServiceBtoB.getContactPointAddresses';
import getSingleSupplierCartItems from '@salesforce/apex/WebCareStockPriceCheckBtoB.getSingleSupplierCartItems';
import setCartItemDeliveryAddress from '@salesforce/apex/WebCareCartServiceBtoB.updateCartItemDeliveryAddresses';
import updateCartItem from '@salesforce/apex/WebCareCartServiceBtoB.updateCartItem';
import deleteCartItem from '@salesforce/apex/WebCareCartServiceBtoB.deleteCartItem';
import validateSingleCart from '@salesforce/apex/WebCareStockPriceCheck.getSingleSupplierCartItems';
import validateWholeCart from '@salesforce/apex/WebCareStockPriceCheck.getAllCartItems';

import BToBCart_TotalCart from '@salesforce/label/c.BToBCart_TotalCart';
import BToBCart_Checkout from '@salesforce/label/c.BToBCart_Checkout';
import BToBCart_CartHeader from '@salesforce/label/c.BToBCart_CartHeader';
import BToBCart_Brand from '@salesforce/label/c.BToBCart_Brand';
import BToBCart_Description from '@salesforce/label/c.BToBCart_Description';
import BToBCart_Recytyre from '@salesforce/label/c.BToBCart_Recytyre';
import BToBCart_Quantity from '@salesforce/label/c.BToBCart_Quantity';
import BToBCart_Price from '@salesforce/label/c.BToBCart_Price';
import BToBCart_DeliveryDate from '@salesforce/label/c.BToBCart_DeliveryDate';
import BToBCart_Comments from '@salesforce/label/c.BToBCart_Comments';
import BToBCart_DeliveryAddress from '@salesforce/label/c.BToBCart_DeliveryAddress';
import BToBCart_Total from '@salesforce/label/c.BToBCart_Total';
import BToBCart_TotalProducts from '@salesforce/label/c.BToBCart_TotalProducts';
import BToBCart_TotalDeliveryCost from '@salesforce/label/c.BToBCart_TotalDeliveryCost';
import BToBCart_TotalLabelCost from '@salesforce/label/c.BToBCart_TotalLabelCost';
import BToBCart_TotalExVAT from '@salesforce/label/c.BToBCart_TotalExVAT';
import BToBCart_Vat from '@salesforce/label/c.BToBCart_Vat';
import BToBCart_TotalIncVat from '@salesforce/label/c.BToBCart_TotalIncVat';
import BToBCart_CheckOrder from '@salesforce/label/c.BToBCart_CheckOrder';
import BToBCart_CreditLimit from '@salesforce/label/c.BToBCart_CreditLimit';
import BToBCart_Transport from '@salesforce/label/c.BToBCart_Transport';
import BToBCart_Recyclage from '@salesforce/label/c.BToBCart_Recyclage';

**/


export default class CartSplit extends LightningElement {


    @api
    recordId;

    @api
    effectiveAccountId;

    @wire(CurrentPageReference)
    pageRef;
    _cartItemCount = 0;
    @track cart = '';
    cartId = '';
    supplierCode = '';

    @api
    currencyCode;

    showLoader = false;

    /**

    @track contactPointAddressesOptions;
    @track contactPointAddressesValue;
    @track contactPointAddressesDefault;
    @track totalProductCount;
    @track cartHeader;

    deliveryAdresses = new Map();

    bToBCart_TotalCart = BToBCart_TotalCart;
    bToBCart_Checkout = BToBCart_Checkout;
    bToBCart_CartHeader = BToBCart_CartHeader;
    bToBCart_Brand = BToBCart_Brand;
    bToBCart_Description = BToBCart_Description;
    bToBCart_Recytyre = BToBCart_Recytyre;
    bToBCart_Quantity = BToBCart_Quantity;
    bToBCart_Price = BToBCart_Price;
    bToBCart_DeliveryDate = BToBCart_DeliveryDate;
    bToBCart_Comments = BToBCart_Comments;
    bToBCart_DeliveryAddress = BToBCart_DeliveryAddress;
    bToBCart_Total = BToBCart_Total;
    bToBCart_TotalProducts = BToBCart_TotalProducts;
    bToBCart_TotalDeliveryCost = BToBCart_TotalDeliveryCost;
    bToBCart_TotalLabelCost = BToBCart_TotalLabelCost;
    bToBCart_TotalExVAT = BToBCart_TotalExVAT;
    bToBCart_Vat = BToBCart_Vat;
    bToBCart_TotalIncVat = BToBCart_TotalIncVat;
    bToBCart_CheckOrder = BToBCart_CheckOrder;
    bToBCart_CreditLimit = BToBCart_CreditLimit;
    bToBCart_Transport = BToBCart_Transport;
    bToBCart_Recyclage = BToBCart_Recyclage;


    connectedCallback() {
        this.showLoader = true;
        loadStyle(this, cartSplitStyle);


        getWebCareTotalItems({recordId: this.recordId})
            .then(result => {
                this.totalProductCount = result;
                this.cartHeader = this.bToBCart_CartHeader + ' (' + this.totalProductCount + ')';
            })


        getWebCareCartItems({recordId: this.recordId})
            .then(result => {
                this.cart = JSON.parse(result);
                this.showLoader = false;
            })
        getContactPointAddresses({recordId: this.recordId})
            .then(result => {
                let options = [];
                let deliveryAddresses = new Map();
                if (result) {
                    result.forEach(r => {
                        if(r.IsDefault = true) {
                            this.contactPointAddressesValue = r.Street + ' ' + r.City + ', ' + r.PostalCode + ' ' + r.Country;
                            this.contactPointAddressesDefault = r.Street + ' ' + r.City + ', ' + r.PostalCode + ' ' + r.Country;
                        }
                        options.push({
                            label: r.Name + " (" + r.Street + ' ' + r.City + ', ' + r.PostalCode + ' ' + r.Country + ")",
                            value: r.Street + ' ' + r.City + ', ' + r.PostalCode + ' ' + r.Country
                        });
                        //Create a map of delivery addresses so that we can retrieve the Record Id later on
                        deliveryAddresses.set(
                            r.Street + ' ' + r.City + ', ' + r.PostalCode + ' ' + r.Country,
                            r.Id
                        );
                    });
                }
                this.contactPointAddressesOptions = options;
                this.deliveryAdresses = deliveryAddresses;
            })
    }

    renderedCallback() {
        var trs = this.template.querySelectorAll('.tr-data');
        var backgroundAffected = false;
        for (var i = 0; i < trs.length; i += 2) {
            backgroundAffected = false;
            var index = trs[i].getAttribute('data-index');
            const items = this.template.querySelectorAll('[data-index="' +index+ '"]');
            for (var j = 0; j < items.length; j += 2) {
                if(backgroundAffected){
                    items[j].style.background = '#eaeaea';
                    items[j + 1].style.background = '#eaeaea';
                    backgroundAffected = false;
                } else{
                    items[j].style.background = '#ffffff';
                    items[j + 1].style.background = '#ffffff';
                    backgroundAffected = true;
                }
            }
        }
    }

    checkSingleSupplierOrder(event) {
        const totalCostIncVat = event.target.dataset.totalCostIncVat;
        const supplierType = event.target.dataset.supplierType;
        const supplierCode = event.target.dataset.itemId;
        const tds = this.template.querySelectorAll('[data-td-id="' +supplierCode+ '"]');
        var msg = this.bToBCart_CreditLimit.replace('#Available_Credit#', this.cart.availableCredit);
        msg = msg.replace('#Credit_Limit#', this.cart.creditLimit);
        if(supplierType == 'Alternative'){
            if(parseFloat(totalCostIncVat) > parseFloat(this.cart.availableCredit)){
                const event = new ShowToastEvent({
                    message: msg,
                    variant: 'error'
                });
                this.dispatchEvent(event);
                for (var i = 0; i < tds.length; i++) {
                    tds[i].style.color = 'red';
                }
            }
        }

        validateSingleCart({cartId: this.recordId, supplierCode: supplierCode})
            .then(result => {
                console.log('result', result);
                //this.cart = JSON.parse(result);
            })
            .catch(error => {
                console.log('error', error);
            });
    }
    globalCheckout() {
        if(parseFloat(this.cart.globalCostIncVat) > parseFloat(this.cart.availableCredit)){
            const tds = this.template.querySelectorAll('[data-td-type="Alternative"]');
            var msg = this.bToBCart_CreditLimit.replace('#Available_Credit#', this.cart.availableCredit);
            msg = msg.replace('#Credit_Limit#', this.cart.creditLimit);
            const event = new ShowToastEvent({
                message: msg,
                variant: 'error'
            });
            this.dispatchEvent(event);
            for (var i = 0; i < tds.length; i++) {
                tds[i].style.color = 'red';
            }
        }
        console.log('sending cart with cartId ' +this.recordId);
        validateWholeCart({cartId: this.recordId})
            .then(result => {
                console.log('result', result);
                //this.cart = JSON.parse(result);
            })
            .catch(error => {
                console.log('error', error);
            });
    }


    handleContactPointAddressesChange(event) {

        let supplier = event.target.dataset.supplier;
        let deliveryAddressId = this.deliveryAdresses.get(this.contactPointAddressesValue);
        let address = event.target.value;
        console.log('supplier', supplier);
        console.log('map check : ' +deliveryAddressId);
        console.log('address', address);

        setCartItemDeliveryAddress({supplierCode: supplier, cartId: this.recordId, deliveryAddressId: deliveryAddressId})
            .then(result => {
                console.log('result', result);
            })
            .catch(error => {
                console.log('error', error);
            });
    }

    handleCommentChange(event) {
        let cartItemId = event.target.dataset.cartItemId;
        let cartItem = { 'sobjectType': 'CartItem' };
        cartItem.Id = cartItemId;
        cartItem.Comment__c = (event.target.value).substring(0, 255);
        updateCartItem({cartItem: cartItem})
            .then(result => {
                this.connectedCallback();
            })
            .catch(error => {
                console.log('updateCartItem error', error);
            });
    }

    handleQuantityChange(event) {
        let cartItemId = event.target.dataset.cartItemId;
        let cartItem = { 'sobjectType': 'CartItem' };
        cartItem.Id = cartItemId;
        cartItem.Quantity = event.target.value;
        updateCartItem({cartItem: cartItem})
            .then(result => {
                this.connectedCallback();
            })
            .catch(error => {
                console.log('updateCartItem error', error);
            });
    }

    deleteCartItem(event) {
        let cartItemId = event.target.dataset.cartItemId;
        deleteCartItem({cartItemId: cartItemId})
            .then(result => {
                this.connectedCallback();
            })
            .catch(error => {
                console.log('deleteCartItem error', error);
            });
    }
    **/

}