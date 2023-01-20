/* created by :
    Abdelhafid Khribech
    on 02/12/2022
*/
import { LightningElement,wire,track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {
    publish,
    MessageContext
} from "lightning/messageService";
import { loadStyle } from 'lightning/platformResourceLoader';
import styleListBox from '@salesforce/resourceUrl/styleListBox';
import cartChanged from "@salesforce/messageChannel/lightning__commerce_cartChanged";
import getAxies from '@salesforce/apex/ProductController.getAxies';
//import getMotoSeasons from '@salesforce/apex/ProductController.getMotoSeasons';
//import getPositions from '@salesforce/apex/ProductController.getPositions';
//import getUsages from '@salesforce/apex/ProductController.getUsages';
//import getRubbers from '@salesforce/apex/ProductController.getRubbers';
//import getTypes from '@salesforce/apex/ProductController.getTypes';
import getUses from '@salesforce/apex/ProductController.getUses';
import getHeights from '@salesforce/apex/ProductController.getHeights';
import getWidths from '@salesforce/apex/ProductController.getWidths';
import getInches from '@salesforce/apex/ProductController.getInches';
import getCapacities from '@salesforce/apex/ProductController.getCapacities';
import getSpeeds from '@salesforce/apex/ProductController.getSpeeds';
import getCategories from '@salesforce/apex/ProductController.getCategories';
import getSearchResults from '@salesforce/apex/ProductSearchController.search';
import setFavoriteBrands from '@salesforce/apex/ProductSearchController.saveFavoriteBrands';
import getFavoriteBrands from '@salesforce/apex/ProductSearchController.getFavoriteBrands';
import getEffectiveAccount from '@salesforce/apex/CartController.getEffectiveAccount';
import getUserType from '@salesforce/apex/ProductSearchController.getUserType';
import getBrands from '@salesforce/apex/ProductController.getBrands';
import getFuels from '@salesforce/apex/ProductController.getFuels';
import getGrips from '@salesforce/apex/ProductController.getGrips';
import getNoises from '@salesforce/apex/ProductController.getNoises';
import getSpecifications from '@salesforce/apex/ProductController.getSpecifications';
import getHomologations from '@salesforce/apex/ProductController.getHomologations';
import getSeasons from '@salesforce/apex/ProductController.getSeasons';
import addItemToCart from '@salesforce/apex/CartController.addItemToCart';
import FUEL from "@salesforce/resourceUrl/Fuel";
import GRIP from "@salesforce/resourceUrl/Grip";
import NOISE from "@salesforce/resourceUrl/Noise";
import BRAND_LABEL from '@salesforce/label/c.BToBSearch_Brand';
import BRANDS_HELP_TEXT from '@salesforce/label/c.BToBSearch_BrandsHelpText';
import CATEGORY_BUTTON from '@salesforce/label/c.BToBSearch_CategoryButton';
import CATEGORY_LABEL from '@salesforce/label/c.BToBSearch_CategoryLabel';
import CHOOSE_PLACEHOLDER from '@salesforce/label/c.BToBSearch_ChoosePlaceholder';
import CLEAR_BUTTON from '@salesforce/label/c.BToBSearch_ClearButton';
import FAVORITE_BUTTON_LABEL from '@salesforce/label/c.BToBSearch_FavoriteButtonLabel';
import FUEL_LABEL from '@salesforce/label/c.BToBSearch_FuelLabel';
import GRIP_LABEL from '@salesforce/label/c.BToBSearch_GripLabel';
import HEIGHT_LABEL from '@salesforce/label/c.BToBSearch_HeightLabel';
import HOMOLOGATION_LABEL from '@salesforce/label/c.BToBSearch_HomologationLabel';
import INCHES_LABEL from '@salesforce/label/c.BToBSearch_InchesLabel';
import LABEL_BUTTON from '@salesforce/label/c.BToBSearch_LabelButton';
import LOAD_CAPACITY_LABEL from '@salesforce/label/c.BToBSearch_LoadCapacityLabel';
import NO_DATA_MESSAGE from '@salesforce/label/c.BToBSearch_NoDataMessage';
import NOISE_LABEL from '@salesforce/label/c.BToBSearch_NoiseLabel';
import RUNFLAT_LABEL from '@salesforce/label/c.BToBSearch_RunflatLabel';
import SEARCH_BUTTON from '@salesforce/label/c.BToBSearch_SearchButton';
import SEARCH_TERM from '@salesforce/label/c.BToBSearch_SearchTerm';
import SEASON_PICKLIST_LABEL from '@salesforce/label/c.BToBSearch_SeasonLabel';
import SELECT_BRANDS_LABEL from '@salesforce/label/c.BToBSearch_SelectBrandsLabel';
import SPECIFICATION_BUTTON from '@salesforce/label/c.BToBSearch_SpecificationsButton';
import SPECIFICATION_LABEL from '@salesforce/label/c.BToBSearch_SpecificationsLabel';
import SPEED_INDEX_LABEL from '@salesforce/label/c.BToBSearch_SpeedIndexLabel';
import TYRE_DETAILS_BUTTON from '@salesforce/label/c.BToBSearch_TyreDetailsButton';
import WIDTH_LABEL from '@salesforce/label/c.BToBSearch_WidthLabel';
import SEASON_LABEL from '@salesforce/label/c.BToBSearch_Season';
import DESCRIPTION_LABEL from '@salesforce/label/c.BToBSearch_Description';
import SUPPLIER_LABEL from '@salesforce/label/c.BToBSearch_Supplier';
import LISTPRICE_LABEL from '@salesforce/label/c.BToBSearch_ListPrice';
import SALESPRICE_LABEL from '@salesforce/label/c.BToBSearch_SalesPrice';
import DELIVERYDATE_LABEL from '@salesforce/label/c.BToBSearch_DeliveryDate';
import STOCK_LABEL from '@salesforce/label/c.BToBSearch_Stock';
import QUANTITY_LABEL from '@salesforce/label/c.BToBSearch_Quantity';
import PMSF_LABEL from '@salesforce/label/c.BToBSearch_3PMSF';
import SEAL_LABEL from '@salesforce/label/c.BToBSearch_Seal';	
import SOUND_LABEL from '@salesforce/label/c.BToBSearch_Sound';
import ELT_LABEL from '@salesforce/label/c.BToBSearch_Elt';
import USE_LABEL from '@salesforce/label/c.BToBSearch_Use';
import AXIS_LABEL from '@salesforce/label/c.BToBSearch_Axis';
import POSITION_LABEL from '@salesforce/label/c.BToBSearch_Position';
import TYPE_LABEL from '@salesforce/label/c.BToBSearch_Type';
import USAGE_LABEL from '@salesforce/label/c.BToBSearch_Usage';
import RUBBER_LABEL from '@salesforce/label/c.BToBSearch_RubberHardness';
import BRAND_PLACEHOLDER from '@salesforce/label/c.BToBSearch_BrandPlaceholder';
import AVAILABLE_BRANDS from '@salesforce/label/c.BToBSearch_AvailableBrands';
import SELECTED_BRANDS from '@salesforce/label/c.BToBSearch_SelectedBrands';

import DISTRIBUTIONDISCOUNT_LABEL from '@salesforce/label/c.BToBSearch_DistributionDiscount';
import Id from '@salesforce/user/Id';


export default class ProductSearch extends LightningElement {

    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';
    variantOptions = [
        { label: 'error', value: 'error' },
        { label: 'warning', value: 'warning' },
        { label: 'success', value: 'success' },
        { label: 'info', value: 'info' },
    ];

    //COLS LABELS && CUSTOM LABELS
    seasonLabel = SEASON_LABEL;
    brandLabel = BRAND_LABEL;
    descriptionLabel = DESCRIPTION_LABEL;
    supplierLabel = SUPPLIER_LABEL;
    listPriceLabel = LISTPRICE_LABEL;
    salesPriceLabel = SALESPRICE_LABEL;
    deliveryDateLabel = DELIVERYDATE_LABEL;
    stockLabel = STOCK_LABEL;
    quantityLabel = QUANTITY_LABEL;
    brandsHelpText = BRANDS_HELP_TEXT;
    CategoryButton = CATEGORY_BUTTON;
    categoryLabel = CATEGORY_LABEL;
    choosePlaceholder = CHOOSE_PLACEHOLDER;
    clearButton = CLEAR_BUTTON;
    favoriteButtonLabel = FAVORITE_BUTTON_LABEL;
    fuelLabel = FUEL_LABEL;
    gripLabel = GRIP_LABEL;
    heightLabel = HEIGHT_LABEL;
    homologationLabel = HOMOLOGATION_LABEL;
    inchesLabel = INCHES_LABEL;
    LabelButton = LABEL_BUTTON;
    loadCapacityLabel = LOAD_CAPACITY_LABEL;
    noDataMessage = NO_DATA_MESSAGE;
    noiseLabel = NOISE_LABEL;
    runflatLabel = RUNFLAT_LABEL;
    searchButton = SEARCH_BUTTON;
    searchTermPlaceholder = SEARCH_TERM;
    seasonPicklistLabel = SEASON_PICKLIST_LABEL;
    selectBrandsLabel = SELECT_BRANDS_LABEL;
    specificationButton = SPECIFICATION_BUTTON;
    specificationLabel = SPECIFICATION_LABEL;
    speedIndexLabel = SPEED_INDEX_LABEL;
    tyreDetailsButton = TYRE_DETAILS_BUTTON;
    widthLabel = WIDTH_LABEL;
    pmsfLabel = PMSF_LABEL;
    sealLabel = SEAL_LABEL;
    soundLabel = SOUND_LABEL;
    eltLabel = ELT_LABEL;
    useLabel = USE_LABEL;
    axisLabel = AXIS_LABEL;
    positionLabel = POSITION_LABEL;
    typeLabel = TYPE_LABEL;
    usageLabel = USAGE_LABEL;
    rubberLabel = RUBBER_LABEL;
    brandPlaceholder = BRAND_PLACEHOLDER;
    selectedBrandsLabel = SELECTED_BRANDS;
    availableBrandsLabel = AVAILABLE_BRANDS;
    fuelImage = FUEL;
    gripImage = GRIP;
    noiseImage = NOISE;
    distributionDiscount = DISTRIBUTIONDISCOUNT_LABEL;
    @api recordType;
    @track searchResultsSize;
    @track showNoDataMessage = false;
    @track noResults = false;
    @track showDistributionColonne = false;
    noDataMessage = 'There is no data for the current search';
    //Disable combobox selections
    @track showLabelFilter = false;
    @track showSpecificationFilter = false;
    @track showRightFilters = false
    @track showDimensionFilter = false;
    @track showCategoryFilter = false; 
    @track showTypeFilter = false;
    @track disabledHeigth = true;
    @track disabledInches = true;
    @track disabledCapacity = true;
    @track disabledSpeed = true;
    @track disabledGrip = false;
    @track disabledNoise = false;
    @track showCarFilter = false;
    @track showMotoFilter = false;
    @track showTruckFilter = false;
    //BRANDS DUAL LISTBOX ATTRIBUTES
    @track useOptions;
    @track axisOptions;
    @track motoSeasonsOptions;
    @track positionOptions;
    @track usageOptions;
    @track rubberOptions;
    @track fuelOptions;
    @track gripOptions;
    @track noiseOptions;
    @track heightOptions = [];
    @track widthOptions;
    @track inchesOptions;
    @track capacityOptions;
    @track categoryOptions;
    @track speedOptions;
    @track brandsOptions;
    options = [];
    @track homologationOptions;
    @track specificationOptions;
    @track isLoaded = true;

    @track searchResults = [];
    @track allSearchResults = [];

    @track fuelValue;
    @track gripValue;
    @track noiseValue;
    @track heightValue;
    @track widthValue;
    @track widthValueNumber;
    @track categoryValue;
    @track typeValue;
    @track inchesValue;
    @track capacityValue;
    @track speedValue;
    @track brandValue;
    @track seasonValue;
    @track motoSeasonValue;
    @track positionValue;
    @track usageValue;
    @track rubberValue;
    @track useValue;
    @track axisValue;
    @track homologationValue;
    @track runflatValue = null;
    @track pmsfValue = null;
    @track sealValue = null;
    @track soundValue = null;
    @track eltValue = null;
    @track specificationValue;
    @track product;
    @track left;
    @track top;
    @track selectedBrands;
    @track totalRecords;
    @track showpop;
    userId = Id;
    @track searchTerm;
    pageSize = 25;
    offset = 0;
    // homologationTerm;
    effectiveAccount;

    get sortOptionValues() {
        return [
                 { label: 'Price - Lowest First', value: 'Price Ascending' },
                 { label: 'Delivery Date - Earliest First', value: 'Date Ascending' }
             ];
    }

    // get seasonOptions() {
    //     return [
    //         { label: 'All Seasons', value: 'All Seasons' },
    //         { label: 'Summer', value: 'Summer' },
    //         { label: 'Winter', value: 'Winter' }
    //     ];
    // }
//----------------------------------------------CONTROLLER----------------------------------------------------------//
    brandFilter(event) {        
        let filter = event? new RegExp(this.template.querySelector('[data-id="filterField"]').value, 'i'):
        { test: function() { return true }};
        console.log('filter', JSON.stringify(filter));
        console.log('querySelector', this.template.querySelector('[data-id="filterField"]').value);
        const selected = new Set(this.selectedBrands)
        this.options = this.brandsOptions.filter(option => (filter.test(option.value) || selected.has(option.value)));
        console.log('options', JSON.stringify(this.options));
    }
    search() {
        console.log(
            'recordtype :',this.recordType,
            'TYPE :',this.typeValue,
            'fuelValue :',this.fuelValue,
            'gripValue :',this.gripValue,
            'noiseValue :',this.noiseValue,
            'heightValue :',this.heightValue,
            'widthValue :',this.widthValue,
            'inchesValue :',this.inchesValue,
            'capacityValue :',this.capacityValue,
            'speedValue :',this.speedValue,
            'brandValue:', this.brandValue,
            'selectedBrands:', this.selectedBrands,
            'seasonValue:', this.seasonValue,
            'useValue:', this.useValue,
            'axisValue:', this.axisValue,
            'typeValue:', this.typeValue,
            'motoSeasonValue:', this.motoSeasonValue,
            'positionValue:', this.positionValue,
            'usageValue:', this.usageValue,
            'rubberValue:', this.rubberValue,
            'searchTerm:', this.searchTerm,
            'categoryValue:', this.categoryValue,
            'homologationValue:', this.homologationValue,
            'specificationValue:', this.specificationValue);
        //Check whether at least one filter is selected, and throw an error if not
        console.log(this.fuelValue === undefined || this.fuelValue === null);
        if(this.fuelValue === undefined || this.fuelValue === null){
            console.log('fuelValue is null');
        } else {
            console.log('fuelValue is not null');
        }
        if (
            (this.fuelValue === undefined || this.fuelValue === null) &&
            (this.gripValue === undefined || this.gripValue === null) &&
            (this.noiseValue === undefined || this.noiseValue === null) &&
            (this.heightValue === undefined || this.heightValue === null) &&
            (this.widthValue === undefined || this.widthValue === null) &&
            (this.inchesValue === undefined || this.inchesValue === null) &&
            (this.capacityValue === undefined || this.capacityValue === null) &&
            (this.speedValue === undefined || this.speedValue === null) &&
            (this.brandValue === undefined || this.brandValue === null) &&
            (this.seasonValue === undefined || this.seasonValue === null) &&
            (this.useValue === undefined || this.useValue === null) &&
            (this.axisValue === undefined || this.axisValue === null) &&
            (this.typeValue === undefined || this.typeValue === null) &&
            (this.motoSeasonValue === undefined || this.motoSeasonValue === null) &&
            (this.positionValue === undefined || this.positionValue === null) &&
            (this.usageValue === undefined || this.usageValue === null) &&
            (this.rubberValue === undefined || this.rubberValue === null) &&
            (this.searchTerm === undefined || this.searchTerm === null) &&
            (this.categoryValue === undefined || this.categoryValue === null) &&
            (this.homologationValue === undefined || this.homologationValue === null) &&
            (this.specificationValue === undefined || this.specificationValue === null)
        ) {
            console.log('No filters selected');
            this._title = 'Warning';
            this.variant = 'warning';
            this.message = 'Please select at least one filter to search on';
            this.showNotification();
        } else {
            console.log('Filters selected');
            console.log('selected Brand ' + this.selectedBrands);
            this.noResults = true;
            this.isLoaded = !this.isLoaded;
            getSearchResults({
                recordType : this.recordType,
                Dim1: this.widthValue,
                Serie: this.heightValue,
                Dim3: this.inchesValue,
                capacity: this.capacityValue,
                speed: this.speedValue,
                searchTerm: this.searchTerm,
                brand: this.selectedBrands === undefined ? null : this.selectedBrands.toString(),
                season: this.seasonValue,
                use: this.useValue,
                axis: this.axisValue,
                fuel: this.fuelValue,
                grip: this.gripValue,
                noise: this.noiseValue,
                type: this.typeValue,
                //motoSeason: this.motoSeasonValue,
                position: this.positionValue,
                usage: this.usageValue,
                rubber: this.rubberValue,
                category: this.categoryValue,
                specification : this.specificationValue,
                homologation : this.homologationValue,
                runflat : this.runflatValue, 
                pmsf : this.pmsfValue, 
                seal : this.sealValue, 
                sound : this.soundValue, 
                elt : this.eltValue,
                offset: this.offset
            })
                .then((data) => {
                    this.isLoaded = true;
                    console.log('this record type :',this.recordType);
                    if(data != '[]'){
                        this.searchResults = JSON.parse(data);
                        console.log('searchResults id : ', this.searchResults[0].id);
                        console.log('searchResults : ', this.searchResults[0].totalRecords);
                        console.log('searchResults size = ' + this.searchResults.length);
                        this.searchResultsSize = this.searchResults.length;
                        this.showNoDataMessage = false;
                        this.noResults = true;
                        this.totalRecords = this.searchResults[0].totalRecords; 
                    }else{
                        this.showNoDataMessage = true;
                        this.noResults = false;
                    }
                })
                .catch((error) => {
                    console.log(error);
                    this.isLoaded = !this.isLoaded;
                });
        }
    }

    saveFavorite(event){

        setFavoriteBrands({brand: this.selectedBrands, userId: this.userId})
            .then((data) => {
                console.log('data : ',data);
                this._title = 'Success';
                this.message = 'Your favorite brands have been saved';
                this.variant = 'success';
                this.showNotification();
            })
            .catch((error) =>{
                console.log(error);
            });
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }

    showAllWhsLines(event){
        let index = event.target.dataset.index;
        console.log('index : ',index);
        this.searchResults[index].wholesalers[0].buttonState = !this.searchResults[index].wholesalers[0].buttonState;
        for(let i = 1; i < this.searchResults[index].wholesalers.length; i++){
            console.log('wholesalers before: ',JSON.stringify(this.searchResults[index].wholesalers[i]));
            this.searchResults[index].wholesalers[i].showLine = !this.searchResults[index].wholesalers[i].showLine;
            console.log('wholesalers after: ',JSON.stringify(this.searchResults[index].wholesalers[i]));
        }
    }

    showAllMfgLines(event){
        let index = event.target.dataset.index;
        console.log('index : ',index);
        this.searchResults[index].manufacturers[0].buttonState = !this.searchResults[index].manufacturers[0].buttonState;
        for(let i = 1; i < this.searchResults[index].manufacturers.length; i++){
            console.log('manufacturers before: ',JSON.stringify(this.searchResults[index].manufacturers[i]));
            this.searchResults[index].manufacturers[i].showLine = !this.searchResults[index].manufacturers[i].showLine;
            console.log('manufacturers after: ',JSON.stringify(this.searchResults[index].manufacturers[i]));
        }
    }

//----------------------------------------------WIRES------------------------------------------------------------//

    connectedCallback() {
        loadStyle(this, styleListBox); 
        if(this.recordType === 'Car'){
            this.showCarFilter = true;
            this.showTruckFilter = false;
            this.showMotoFilter = false;
        }
        else if(this.recordType === 'Truck'){
            this.showTruckFilter = true;
            this.showCarFilter = false;
            this.showMotoFilter = false;
        }
        else if(this.recordType === 'Moto'){
            this.showMotoFilter = true;
            this.showTruckFilter = false;
            this.showCarFilter = false;
        }
        // this.filter();
        this.userId = Id;
        console.log('this user : ',this.userId);
        console.log('show moto filter : ',this.showMotoFilter);
        getEffectiveAccount({userId: this.userId})
            .then((data) => {
                this.effectiveAccount = data;
                console.log('this.effectiveAccount : ',this.effectiveAccount);
            })
            .catch((error) =>{
                console.log(error);
            });
        getFavoriteBrands({userId: this.userId})
            .then((data) => {
                let brandList = data.split(',');
                let tempSelectedBrands = [];
                brandList.forEach((brandValue) => {
                    tempSelectedBrands.push(brandValue.trim());
                    });
                this.selectedBrands = tempSelectedBrands;
            })
            .catch((error) =>{
                console.log(error);
            });
        getGrips({ recordType : this.recordType, fuel : this.fuelValue})
            .then((data) => {
                this.gripOptions = JSON.parse(JSON.stringify(data));
            })
            .catch((error) =>{
                console.log(error);
            })
        getNoises({ recordType : this.recordType, fuel : this.fuelValue, grip : this.gripValue})
            .then((data) => {
                this.noiseOptions = JSON.parse(JSON.stringify(data));
            })
            .catch((error) =>{
                console.log(error);
            })
        getUserType({userId: this.userId})
        .then((data)=> {
            console.log('user type pb :',data);
            if(data === 'd1' || data === 'd2' || data === 'd3'){
                this.showDistributionColonne = true;
            }
        })
        .catch((error) =>{
            console.log(error);
        });
    }

    @wire(getBrands,{recordType : '$recordType'})
    getBrands(result){
        if(result.data){
            //this.brandsOptions = [{ label: 'None', value: '', selected: true }, ...JSON.parse(JSON.stringify(result.data))];
            this.brandsOptions = JSON.parse(JSON.stringify(result.data));
            this.options=this.brandsOptions;
        }else if(result.error){
            console.log(result.error);
        }
    }

    @wire(getWidths,{recordType : '$recordType'})
    getWidths(result) {
        if (result.data) {
            console.log('widhts',result.data);
            this.widthOptions = JSON.parse(JSON.stringify(result.data));
            this.widthOptions.sort((a, b) => a.value - b.value);
        } else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getFuels,{recordType : '$recordType'})
    getFuels(result) {
        if (result.data) {
            this.fuelOptions = JSON.parse(JSON.stringify(result.data));
        } else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getSpecifications)
    getSpecifications(result){
        if (result.data) {
            this.specificationOptions = JSON.parse(JSON.stringify(result.data));
        } else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getHomologations)
    getHomologations(result){
        if (result.data) {
            this.homologationOptions = JSON.parse(JSON.stringify(result.data));
        } else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getCategories)
    getCategories(result){
        if (result.data) {
            this.categoryOptions = JSON.parse(JSON.stringify(result.data));
        } else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getSeasons)
    getSeasons(result){
        if (result.data) {
            this.seasonOptions = JSON.parse(JSON.stringify(result.data));
        } else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getUses)
    getUses(result){
        if (result.data) {
            this.useOptions = JSON.parse(JSON.stringify(result.data));
        } else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getAxies)
    getAxies(result){
        if (result.data) {
            this.axisOptions = JSON.parse(JSON.stringify(result.data));
        } else if (result.error) {
            console.log(result.error);
        }
    }
// Moto filters values
    // @wire(getMotoSeasons)
    // getMotoSeasons(result){
    //     if (result.data) {
    //         this.motoSeasonsOptions = JSON.parse(JSON.stringify(result.data));
    //     } else if (result.error) {
    //         console.log(result.error);
    //     }
    // }

    // @wire(getPositions)
    // getPositions(result){
    //     if (result.data) {
    //         this.positionOptions = JSON.parse(JSON.stringify(result.data));
    //     } else if (result.error) {
    //         console.log(result.error);
    //     }
    // }

    // @wire(getUsages)
    // getUsages(result){
    //     if (result.data) {
    //         this.usageOptions = JSON.parse(JSON.stringify(result.data));
    //     } else if (result.error) {
    //         console.log(result.error);
    //     }
    // }

    // @wire(getRubbers)
    // getRubbers(result){
    //     if (result.data) {
    //         this.rubberOptions = JSON.parse(JSON.stringify(result.data));
    //     } else if (result.error) {
    //         console.log(result.error);
    //     }
    // }

    // @wire(getTypes)
    // getTypes(result){
    //     if (result.data) {
    //         this.typeOptions = JSON.parse(JSON.stringify(result.data));
    //     } else if (result.error) {
    //         console.log(result.error);
    //     }
    // }
// end of Moto filters values
    @wire(MessageContext)
    messageContext;




//----------------------------------------------HANDLER----------------------------------------------------------//

    handleQuantityChange(event){
        let index = event.target.dataset.index;
        let productindex = event.target.dataset.productindex;
        let type = event.target.dataset.type;

        console.log('index : ',index);
        console.log('type : ',type);
        console.log('productindex : ',productindex);

        if(type === 'wholesaler'){
            this.searchResults[index].orderQuantity = event.target.value;
            console.log('wholesaler quantity : ',this.searchResults[index].orderQuantity);

        }
        else if(type === 'manufacturer'){
            this.searchResults[productindex].manufacturers[index].orderQuantity = event.target.value;
            console.log('manufacturer quantity : ',this.searchResults[productindex].manufacturers[index].orderQuantity);
        }
        else if (type === 'wholesaler-other'){
            this.searchResults[productindex].wholesalers[index].orderQuantity = event.target.value;
            console.log('wholesaler-other quantity : ',this.searchResults[productindex].wholesalers[index].orderQuantity);
        }


    }

    clearSearch(){
        this.handleReset();
        this.showNoDataMessage = false;
        this.noResults = false;
        this.searchResults = [];
        this.brandValue = null;
        this.widthValue = null;
        this.fuelValue = null;
        this.gripValue = null;
        this.noiseValue = null;
        this.inchesValue = null;
        this.heightValue = null;
        this.brandValue = null;
        this.capacityValue = null;
        this.speedValue = null;
        this.searchTerm = null;
        this.seasonValue = null;
        this.motoSeasonValue = null;
        this.typeValue = null;
        this.categoryValue = null;
        this.positionValue = null;
        this.usageValue = null;
        this.rubberValue = null;
        this.useValue = null;
        this.axisValue = null;
        this.widthValueNumber = null;
        this.runflatValue = null;
        this.pmsfValue = null;
        this.sealValue = null;
        this.soundValue = null;
        this.eltValue = null;
        this.homologationValue = null;
        this.specificationValue = null;
        console.log('this.seasonValue : ',this.seasonValue);
        console.log('this.motoSeasonValue : ',this.motoSeasonValue);
    }

    handleReset() {
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.type === 'checkbox' || element.type === 'checkbox-button') {
                element.checked = false;
            } else {
                element.value = null;
            }
        })
    }

    handleSearchTermChange(event){
        this.searchTerm = event.target.value;
        console.log('search term : ',this.searchTerm);
    }

    // handleSearchHomologationChange(event){
    //     this.homologationTerm = event.target.value;
    // }

    handleAddToCart(event){
        let productId = event.target.dataset.id;
        let price = event.target.dataset.price;
        let quantity = event.target.dataset.orderquantity;
        let deliveryDate = event.target.dataset.deliverydate;
        console.log('productId : ',productId);
        addItemToCart({productId: productId, quantity: quantity, accountId: this.effectiveAccount, price: price, deliveryDate})
            .then((data) => {
                console.log('data : ',data);
                this._title = 'Success';
                this.variant = 'success';
                this.message = 'Item added to cart';
                this.showNotification();
                publish(this.messageContext, cartChanged);
            })
            .catch((error) =>{
                console.log(error);
            });
    }

    handlePagination(event){
        const start = (event.detail-1)*this.pageSize;
        const end = this.pageSize*event.detail;
        console.log('start & end = ' +start,end);
        this.offset = start;
        this.search();
        this.topFunction();


    }
    

    getNextPage(event){
        console.log('event : ',event);
        this.offset = event.detail.offset;
        console.log('this.start : ',this.offset);
    }

    handleSeasonChangeCar(event){
        this.seasonValue = event.detail.value;
        console.log('seasonValue : ',this.seasonValue);
    }
    handleSeasonChangeMoto(event){
        this.motoSeasonValue = event.detail.value;
        console.log('motoSeasonValue : ',this.motoSeasonValue);
    }
    handlePositionChange(event){
        this.positionValue = event.detail.value;
        console.log('positionValue : ',this.positionValue);
    }

    handleUseChange(event){
        this.useValue = event.detail.value;
        console.log('use',this.useValue);
    }
    handleAxisChange(event){
        this.axisValue = event.detail.value; 
        console.log('axis',this.axisValue);
    }

    handleCategoryValueChange(event){
        this.categoryValue = event.detail.value;
        console.log('categoryValue : ',this.categoryValue);
    }

    handleTypeValueChange(event){
        this.typeValue = event.detail.value;
        console.log('categoryValue : ',this.typeValue);
    }

    //category button that shows the category filter
    handleCategoryChange(event){
        this.showCategoryFilter = this.showCategoryFilter == false ? true:false;
        if(this.showCategoryFilter == false){
            this.categoryValue = null;
        }
    }
    handleTypeChange(event){
        this.showTypeFilter = this.showTypeFilter == false ? true:false;
        if(this.showTypeFilter == false){
            this.typeValue = null;
        }
    }
    // dimension button to show the dimension filter section
    handleDimensionChange(event) {
        this.showDimensionFilter = this.showDimensionFilter == false ? true:false;
        if(this.showDimensionFilter == false){

            this.heightValue = null;
            this.widthValue = null;
            this.inchesValue = null
            this.capacityValue = null;
            this.speedValue = null;
            this.heightOptions = null;
            this.inchesOptions = null;
            this.capacityOptions = null;
            this.speedOptions = null;
            this.disabledHeigth = true;
            this.disabledInches = true;
            this.disabledCapacity = true;
            this.disabledSpeed = true;
            this.motoSeasonValue = null;
            this.positionValue = null;
            this.useValue = null;
            this.axisValue = null;
        }

    }
    //dimesions filter actions
    handleWidthChange(event){

        this.widthValue = event.detail.value;
        this.widthValueNumber = parseFloat(event.detail.value);
        console.log('widthValue : ',this.widthValue);
        console.log('widthValueNumber : ',this.widthValueNumber);
        this.heightValue = null;
        this.inchesValue = null;
        this.capacityValue = null;
        this.speedValue = null;
        console.log('width : ',this.widthValue, 'height :',this.heightValue, 'inches :',this.inchesValue, 'capacity :',this.capacityValue, 'speed :',this.speedValue);
        this.disabledHeigth = false;
        this.disabledInches = true;
        this.disabledCapacity = true;
        this.disabledSpeed = true;
        getHeights({ recordType : this.recordType,width : this.widthValue})
            .then((data) => {
                console.log('widths : ',data)
                this.heightOptions = JSON.parse(JSON.stringify(data));
            })
            .catch((error) =>{
                console.log(error);
            })

    }

    handleHeightChange(event){
        this.heightValue = event.detail.value;
        this.inchesValue = null;
        this.capacityValue = null;
        this.speedValue = null;
        this.disabledInches = false;
        this.disabledCapacity = true;
        this.disabledSpeed = true;
        console.log('width : ',this.widthValue, 'height :',this.heightValue, 'inches :',this.inchesValue, 'capacity :',this.capacityValue, 'speed :',this.speedValue);
        getInches({ recordType : this.recordType, height : this.heightValue , width : this.widthValue})
            .then((data) => {
                console.log('widths : ',data)
                this.inchesOptions = JSON.parse(JSON.stringify(data));
            })
            .catch((error) =>{
                console.log(error);
            })
    }

    handleInchesChange(event){
        this.inchesValue = event.detail.value;
        this.capacityValue = null;
        this.speedValue = null;
        this.disabledCapacity = false;
        this.disabledSpeed = true;
        console.log('width : ',this.widthValue, 'height :',this.heightValue, 'inches :',this.inchesValue, 'capacity :',this.capacityValue, 'speed :',this.speedValue);
        getCapacities({ recordType : this.recordType, height : this.heightValue , width : this.widthValue, inches: this.inchesValue})
            .then((data) => {
                console.log('widths : ',data)
                this.capacityOptions = JSON.parse(JSON.stringify(data));
            })
            .catch((error) =>{
                console.log(error);
            })
    }

    handleCapacityChange(event){
        this.capacityValue = event.detail.value;
        this.speedValue = null;
        this.disabledSpeed = false;
        console.log('width : ',this.widthValue, 'height :',this.heightValue, 'inches :',this.inchesValue, 'capacity :',this.capacityValue, 'speed :',this.speedValue);
        getSpeeds({ recordType : this.recordType, height : this.heightValue , width : this.widthValue, inches: this.inchesValue, capacity:this.capacityValue})
            .then((data) => {
                console.log('widths : ',data)
                this.speedOptions = JSON.parse(JSON.stringify(data));
            })
            .catch((error) =>{
                console.log(error);
            })
    }

    handleSpeedChange(event){
        this.speedValue = event.detail.value;
        console.log('width : ',this.widthValue, 'height :',this.heightValue, 'inches :',this.inchesValue, 'capacity :',this.capacityValue, 'speed :',this.speedValue);
    }

    // label button to show the labeling filter section
    handleLabelChange(event) {
        this.showLabelFilter = this.showLabelFilter == false ? true:false;
        this.showRightFilters = this.showLabelFilter || this.showSpecificationFilter;
        if(this.showLabelFilter == false){

            this.fuelValue = null;
            this.gripValue = null;
            this.noiseValue = null
            this.gripOptions = null;
            this.noiseOptions = null;
            this.disabledGrip = true;
            this.disabledNoise = true;
        }
    }
    //specifications button to show the specification filter section
    handleSpecificationChange(event){
        this.showSpecificationFilter = this.showSpecificationFilter == false ? true:false;
        this.showRightFilters = this.showLabelFilter || this.showSpecificationFilter;
        if(this.showSpecificationFilter == false){
            this.runflatValue = null;
            this.pmsfValue = null;
            this.sealValue = null;
            this.soundValue = null;
            this.eltValue = null;
            this.homologationValue = null;
            this.specificationValue = null;
            this.usageValue = null;
            this.rubberValue = null;
        }
    }

    //labelling filters
    handleFuelChange(event){
        this.fuelValue = event.detail.value;
        //this.gripValue = null;
        //this.noiseValue = null;
        this.disabledGrip = false;
        this.disabledNoise = false;
        getGrips({ recordType : this.recordType, fuel : this.fuelValue})
            .then((data) => {
                this.gripOptions = JSON.parse(JSON.stringify(data));
            })
            .catch((error) =>{
                console.log(error);
            })
    }

    handleGripChange(event){
        this.gripValue = event.detail.value;
        this.noiseValue = null;
        this.disabledNoise = false;
        getNoises({ recordType : this.recordType, fuel : this.fuelValue, grip : this.gripValue})
            .then((data) => {
                this.noiseOptions = JSON.parse(JSON.stringify(data));
            })
            .catch((error) =>{
                console.log(error);
            })
    }

    handleNoiseChange(event){
        this.noiseValue = event.detail.value;
        console.log('fuel : ',this.fuelValue, 'grip :',this.gripValue, 'noise :',this.noiseValue);
    }
    handleUsageValueChange(event){
        this.usageValue = event.detail.value;
        console.log('usage :',this.usageValue);
    }
    handleRubberValueChange(event){
        this.rubberValue = event.detail.value;
        console.log('usage :',this.rubberValue);
    }
    //specifications filters
    handleHomologationValueChange(event){
        this.homologationValue = event.detail.value;
        console.log('this homologation :',this.homologationValue);
    }
    handleSpecificationValueChange(event){
        this.specificationValue = event.detail.value;
    }
    handlerunflatValueChange(event){
        this.runflatValue = event.target.checked;
    }
    handlePmsfValueChange(event){
        this.pmsfValue = event.target.checked;
    }
    handleSealValueChange(event){
        this.sealValue = event.target.checked;
    }
    handleSoundValueChange(event){
        this.soundValue = event.target.checked;
    }
    handleEltValueChange(event){
        this.eltValue = event.target.checked;
    }

    closePop(event) {
        this.showpop = event.detail.showpop;
    }

    showData(event){
        this.product = event.target.dataset.productid;
        this.showpop = true;
        this.left = event.clientX;
        this.top = event.pageY;
    }

    hideData(event){
        console.log('hiding data');
        this.product = '';
    }
    get assignClass() {
        return this.active ? '' : 'slds-hint-parent';
    }

    get selected() {
        return this.selectedBrands.length ? this.selectedBrands : 'none';
    }

    handleBrandChange(event) {
        console.log('event : ',event.detail.value);
        this.selectedBrands = event.detail.value;
        this.brandFilter = (true);
        console.log('selectedBrands : ', typeof this.selectedBrands);
        console.log('this.brandValue before: ',this.selectedBrands);
        if(this.selectedBrands.length === 0){
            this.selectedBrands = undefined;
        }
        console.log('this.brandValue after : ',this.selectedBrands);
    }

    topFunction(){
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
    }

//--------------------------------------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------------------------------------//

}