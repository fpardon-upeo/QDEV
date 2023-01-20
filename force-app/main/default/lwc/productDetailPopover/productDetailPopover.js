/**
 * Created by Frederik on 6/12/2022.
 */

import {LightningElement, track, api, wire} from 'lwc';
import GET_PRODUCT from '@salesforce/apex/ProductPopoverController.getProduct';
import getFieldSetMembers from '@salesforce/apex/ProductPopoverController.getFieldSetMembers';
import B2BPopover_Product_Info from '@salesforce/label/c.B2BPopover_Product_Info';
import B2BPopover_Dimensions from '@salesforce/label/c.B2BPopover_Dimensions';
import B2BPopover_Labels from '@salesforce/label/c.B2BPopover_Labels';
import B2BPopover_Product_Specifications from '@salesforce/label/c.B2BPopover_Product_Specifications';
import B2BPopover_Ecotax from '@salesforce/label/c.B2BPopover_Ecotax';
import B2BPopover_Product_Images from '@salesforce/label/c.B2BPopover_Product_Images';

export default class ProductDetailPopover extends LightningElement {

    B2BPopover_Product_Info = B2BPopover_Product_Info;
    B2BPopover_Dimensions = B2BPopover_Dimensions;
    B2BPopover_Labels = B2BPopover_Labels;
    B2BPopover_Product_Specifications = B2BPopover_Product_Specifications;
    B2BPopover_Ecotax = B2BPopover_Ecotax;
    B2BPopover_Product_Images = B2BPopover_Product_Images;


    @track product = '';
    @track top = 50;
    @track left = 50;
    @track productData;
    @track showpopup;

    activeSections = ['ProductInformation'];
    productInformationSectionfields;
    dimensionsSectionfields;
    labelsSectionfields;
    productSpecificationssectionfields;
    ecotaxSectionfields;
    productImagesSectionfields; 

//--------------------------------------------WIRE---------------------------------------------------------------//



//--------------------------------------------GET SET---------------------------------------------------------------//

    @api
    get myproduct(){
        return this.product;
    }

    set myproduct(value) {
        this.product = value;
    }

    @api
    effectiveAccountId;

    @api
    get showpop(){
        return this.showpopup;
    }

    set showpop(value) {
        this.showpopup = value;
    }

    connectedCallback() {
        getFieldSetMembers({objectTypeName: "Product2", fieldSetName: "BToBSearch_Product_Information_Section"})
        .then(result => {
            this.productInformationSectionfields = result;
        })
        getFieldSetMembers({objectTypeName: "Product2", fieldSetName: "BToBSearch_Dimensions_Section"})
            .then(result => {
                this.dimensionsSectionfields = result;
            })
        getFieldSetMembers({objectTypeName: "Product2", fieldSetName: "BToBSearch_Labels_Section"})
            .then(result => {
                this.labelsSectionfields = result;
            })
        getFieldSetMembers({objectTypeName: "Product2", fieldSetName: "BToBSearch_Product_Specifications_Sectio"})
            .then(result => {
                this.productSpecificationssectionfields = result;
            })
        getFieldSetMembers({objectTypeName: "Product2", fieldSetName: "BToBSearch_Ecotax_Section"})
            .then(result => {
                this.ecotaxSectionfields = result;
            })
        getFieldSetMembers({objectTypeName: "Product2", fieldSetName: "BToBSearch_Product_Images_Section"})
            .then(result => {
                this.productImagesSectionfields = result;
            })
    }

    @api
    get topmargin(){
        return this.top;
    }

    set topmargin(value) {
        this.top = value;
    }

    @api
    get leftmargin(){
        return this.left;
    }

    set leftmargin(value) {
        this.left = value;
    }
    get boxClass() {
        //return `position: absolute; background-color:white; top:${this.top-150}px; left:${50}px`;
        return `position: absolute; background-color:white; top:${this.top-150}px; left:${0}px`;
    }

//--------------------------------------------ACTIONS---------------------------------------------------------------//
    closePopover(){
        this.dispatchEvent(new CustomEvent('close',{detail:{showpop:false}}))
    }

}