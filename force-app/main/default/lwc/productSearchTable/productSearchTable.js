/**
 * Created by Frederik on 5/12/2022.
 */

import { LightningElement,wire,track,api } from 'lwc';

import Id from '@salesforce/user/Id';

export default class ProductSearchTable extends LightningElement {

    @track showDimensionFilter = false;
    @track disabledWidth = true;
    @track disabledInches = true;
    @track disabledCapacity = true;
    @track disabledSpeed = true;

    @track heightOptions = [];
    @track widthOptions;
    @track inchesOptions;
    @track capacityOptions;
    @track speedOptions;
    @track isLoaded = true;

    @track searchResults = [];

    @track heightValue;
    @track widthValue;
    @track inchesValue;
    @track capacityValue;
    @track speedValue;

    @track product;
    @track left;
    @track top;
    prevProduct = '';


    userId = Id;
    searchTerm;
    effectiveAccount;
//----------------------------------------------CONTROLLER----------------------------------------------------------//

 
}