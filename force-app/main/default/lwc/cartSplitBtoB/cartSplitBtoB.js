/**
 * Created by Frederik on 29/11/2022.
 */

import { api, wire, track, LightningElement } from 'lwc';
import {
    publish,
    MessageContext
} from "lightning/messageService";
import cartChanged from "@salesforce/messageChannel/lightning__commerce_cartChanged";
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import cartSplitStyle from '@salesforce/resourceUrl/CartSplitStyle';
import getWebCareTotalItems from '@salesforce/apex/WebCareCartServiceBtoB.getWebCareTotalItems';
import getWebCareCartItems from '@salesforce/apex/WebCareCartServiceBtoB.getWebCareCartItems';
import getContactPointAddresses from '@salesforce/apex/WebCareCartServiceBtoB.getContactPointAddresses';
import getSingleSupplierCartItems from '@salesforce/apex/WebCareStockPriceCheck.getSingleSupplierCartItems';
import setCartItemDeliveryAddress from '@salesforce/apex/WebCareCartServiceBtoB.updateCartItemDeliveryAddresses';
import updateCartItem from '@salesforce/apex/WebCareCartServiceBtoB.updateCartItem';
import deleteCartItem from '@salesforce/apex/WebCareCartServiceBtoB.deleteCartItem';
import validateSingleCart from '@salesforce/apex/WebCareStockPriceCheck.getSingleSupplierCartItems';
import validateWholeCart from '@salesforce/apex/WebCareStockPriceCheck.getAllCartItems';


/* Labels */
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
import B2BCart_Warning_Toast_Title	 from '@salesforce/label/c.B2BCart_Warning_Toast_Title';
import B2BCart_Warning_Toast_Message  from '@salesforce/label/c.B2BCart_Warning_Toast_Message';
import B2BCart_Success_Toast_Message from '@salesforce/label/c.B2BCart_Success_Toast_Message';
import B2BCart_No_Longer_Available from '@salesforce/label/c.B2BCart_No_Longer_Available';
import B2BCart_Success_Toast_Title from '@salesforce/label/c.B2BCart_Success_Toast_Title';


export default class CartSplitBtoB extends LightningElement {


    @api
    recordId;

    @api
    effectiveAccountId;

    @wire(CurrentPageReference)
    pageRef;
    @wire(MessageContext)
    messageContext;
    _cartItemCount = 0;
    @track cart = '';
    cartId = '';
    supplierCode = '';

    @api
    currencyCode;

    showLoader = false;

    @track contactPointAddressesOptions;
    @track contactPointAddressesValue;
    @track contactPointAddressesDefault;
    @track totalProductCount;
    @track cartHeader;
    @track isModalAddressOpen = false;
    @track haserrorstd  = false;

    deliveryAdresses = new Map();

    /* Labels */
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
    B2BCart_No_Longer_Available = B2BCart_No_Longer_Available;
    B2BCart_Warning_Toast_Title = B2BCart_Warning_Toast_Title;
    B2BCart_Warning_Toast_Message = B2BCart_Warning_Toast_Message;
    B2BCart_Success_Toast_Message = B2BCart_Success_Toast_Message;
    B2BCart_Success_Toast_Title = B2BCart_Success_Toast_Title;
    currentSupplier;

    /* Toast */
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
                console.log(JSON.stringify(this.cart));
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

        const errors = this.template.querySelectorAll('[data-haserrors="haserrors"]');
        if(errors.length > 0){
            this.haserrorstd = true;
        }
    }

    checkSingleSupplierOrder(event) {
       var valid = true;
       this.showLoader = true;
       const totalCostIncVat = event.target.dataset.totalCostIncVat;
       const supplierType = event.target.dataset.supplierType;
       const supplierCode = event.target.dataset.itemId;
       const tds = this.template.querySelectorAll('[data-td-id="' +supplierCode+ '"]');
       var msg = this.bToBCart_CreditLimit.replace('#Available_Credit#', this.cart.availableCredit);
       msg = msg.replace('#Credit_Limit#', this.cart.creditLimit);
       
       if(supplierType == 'Alternative'){
           if(parseFloat(totalCostIncVat) > parseFloat(this.cart.availableCredit)){
              valid = false;
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
    
        if(valid){
            validateSingleCart({cartId: this.recordId, supplierCode: supplierCode})
            .then(result => {
                this.connectedCallback();
                let ordered = false;
                let validated = false;
                let changed = false;
                result.forEach(r => {
                    console.log('r', r);
                    if(r.Status__c === 'Ordered'){
                        ordered = true;
                    } else {
                        ordered = false;
                    }
                });
                console.log('ordered', ordered);
                if(ordered === true){
                    console.log('showing toast');
                    this._title = B2BCart_Success_Toast_Title;
                    this.message = B2BCart_Success_Toast_Message;
                    this.variant = 'success';
                    this.showNotification();
                } else {
                    this._title = B2BCart_Warning_Toast_Title;
                    this.message = B2BCart_Warning_Toast_Message;
                    this.variant = 'warning';
                    this.showNotification();
                }
            })
           .catch(error => {
               this.showLoader = false;
               console.log('error', error);
           });
        } else{
            this.showLoader = false;
        }
    }

    globalCheckout() {
       var valid = true;
       this.showLoader = true;

        var totalCostAlternative = 0;
        const items = this.template.querySelectorAll('[data-supplier-type="Alternative"]');
        for (var i = 0; i < items.length; i ++) {
            totalCostAlternative += parseFloat(items[i].dataset.totalCostIncVat);
        }
       if(totalCostAlternative > parseFloat(this.cart.availableCredit)){
           valid = false;
           const tds = this.template.querySelectorAll('[data-td-type="Alternative"]');
           var msg = this.bToBCart_CreditLimit.replace('#Available_Credit#', this.cart.availableCredit);
           msg = msg.replace('#Credit_Limit#', this.cart.creditLimit);
           const event = new ShowToastEvent({
               message: msg,
               variant: 'error'
           });
           this.dispatchEvent(event);
           for (i = 0; i < tds.length; i++) {
               tds[i].style.color = 'red';
           }
        }
        if(valid){
            validateWholeCart({cartId: this.recordId})
            .then(result => {
                this.connectedCallback();
                //this.cart = JSON.parse(result);
                let ordered = false;
                result.forEach(r => {
                    if(r.Status__c === 'Ordered'){
                        ordered = true;
                    } else {
                        ordered = false;
                    }
                });
                console.log('ordered', ordered);
                if(ordered === true){
                    console.log('showing toast');
                    this._title = B2BCart_Success_Toast_Title;
                    this.message = B2BCart_Success_Toast_Message;
                    this.variant = 'success';
                    this.showNotification();
                } else {
                    this._title = B2BCart_Warning_Toast_Title;
                    this.message = B2BCart_Warning_Toast_Message;
                    this.variant = 'warning';
                    this.showNotification();
            }
            })
            .catch(error => {
               this.showLoader = false;
                console.log('error', error);
            });
        } else{
            this.showLoader = false;
        }
    }

    handleContactPointAddressesChange(event) {

        this.contactPointAddressesValue = event.detail.value;
        console.log('contactPointAddressesValue', this.contactPointAddressesValue);
        let supplier = event.target.dataset.supplier;
        let deliveryAddressId = this.deliveryAdresses.get(this.contactPointAddressesValue);
        let address = event.target.value;
        console.log('address', address);
        console.log('deliveryAddressId', deliveryAddressId);
        console.log('supplier', supplier);

        setCartItemDeliveryAddress({supplierCode: supplier, cartId: this.recordId, deliveryAddressId: deliveryAddressId})
               .then(result => {
                   console.log('result', result);
               })
               .catch(error => {
                   console.log('error', error);
               });
    }

    handleAddress(event) {
        console.log('event in handleAddress', event);
        let supplier = event.target.dataset.supplier;
        console.log('supplier', supplier);
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
                   publish(this.messageContext, cartChanged);
               })
               .catch(error => {
                   console.log('deleteCartItem error', error);
               });
    }

    openModalAddress(event) {
       this.currentSupplier = event.target.dataset.supplier;
       console.log('this.currentSupplier', this.currentSupplier);
       this.isModalAddressOpen = true;
    }

    closeModalAddress() {
       this.isModalAddressOpen = false;
    }

    submitAddressDetails() {
       this.isModalAddressOpen = false;
       const btn = this.template.querySelector( ".saveaddress" );
       console.log("btn : ", btn);
       this.showLoader = true;
       btn.click();
    }

    handleAddressSubmit(event) {
        let supplier = event.target.dataset.supplier;
        console.log('supplier', supplier);
        console.log('in handleAddressSubmit');
        getContactPointAddresses({recordId: this.recordId})
            .then(result => {
                console.log('calling connectedCallback');
            })
    }

    handleAddressSuccess(event) {
       this.showLoader = false;
       console.log('in handleAddressSuccess');
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
                let r = event.detail.fields;
                let address = r.Street.value + ' ' + r.City.value + ', ' + r.PostalCode.value + ' ' + r.CountryCode.displayValue;
                let supplier = this.currentSupplier;
                let deliveryAddressId = this.deliveryAdresses.get(address);
                console.log('deliveryAddressId', deliveryAddressId);
                console.log('supplier', supplier);
                console.log('address', address);

                setCartItemDeliveryAddress({supplierCode: supplier, cartId: this.recordId, deliveryAddressId: deliveryAddressId})
                    .then(result => {
                        console.log('result', result);
                        this.connectedCallback();
                    })
                    .catch(error => {
                        console.log('error', error);
                    });
            })


    }

    handleError(event) {
        this.showLoader = false;
        console.log('in handleError');
        console.log('event', JSON.stringify(event.detail));
        console.log(event.detail);
        let message = event.detail.message;
        console.log(event.detail.output.fieldErrors.Address[0].message);
        message = event.detail.output.fieldErrors.Address[0].message;
        //do some stuff with message to make it more readable
        this.showToast('Something went wrong', message, 'ERROR');
    }

    showToast(theTitle, theMessage, theVariant) {
        const event = new ShowToastEvent({
            title: theTitle,
            message: theMessage,
            variant: theVariant
        });
        this.dispatchEvent(event);
    }

}