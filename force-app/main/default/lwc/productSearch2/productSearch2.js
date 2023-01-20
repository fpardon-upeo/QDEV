/* created by :
    Abdelhafid Khribech 
    on 02/12/2022 
*/
import { LightningElement,wire,track,api } from 'lwc';
import getVariations from "@salesforce/apex/ProductController.getVariations";
import getHeights from '@salesforce/apex/ProductController.getHeights';
import getWidths from '@salesforce/apex/ProductController.getWidths';
import getInches from '@salesforce/apex/ProductController.getInches';
import getCapacities from '@salesforce/apex/ProductController.getCapacities';
import getSpeeds from '@salesforce/apex/ProductController.getSpeeds';
import getSearchResults from '@salesforce/apex/ProductSearchController.search';
import getEffectiveAccount from '@salesforce/apex/CartController.getEffectiveAccount';
import getBrands from '@salesforce/apex/ProductController.getBrands';
import getFuels from '@salesforce/apex/ProductController.getFuels';
import getGrips from '@salesforce/apex/ProductController.getGrips';
import getNoises from '@salesforce/apex/ProductController.getNoises';
import addItemToCart from '@salesforce/apex/CartController.addItemToCart';
import FUEL from "@salesforce/resourceUrl/Fuel";
import GRIP from "@salesforce/resourceUrl/Grip";
import NOISE from "@salesforce/resourceUrl/Noise";
import BRAND_LABEL from '@salesforce/label/c.BToBSearch_Brand';
import SEASON_LABEL from '@salesforce/label/c.BToBSearch_Season';
import DESCRIPTION_LABEL from '@salesforce/label/c.BToBSearch_Description';
import SUPPLIER_LABEL from '@salesforce/label/c.BToBSearch_Supplier';
import LISTPRICE_LABEL from '@salesforce/label/c.BToBSearch_ListPrice';
import SALESPRICE_LABEL from '@salesforce/label/c.BToBSearch_SalesPrice';
import DELIVERYDATE_LABEL from '@salesforce/label/c.BToBSearch_DeliveryDate';
import STOCK_LABEL from '@salesforce/label/c.BToBSearch_Stock';
import QUANTITY_LABEL from '@salesforce/label/c.BToBSearch_Quantity';
import Id from '@salesforce/user/Id';


export default class ProductSearch2 extends LightningElement {

        //COLS LABELS 
        seasonLabel = SEASON_LABEL;
        brandLabel = BRAND_LABEL;
        descriptionLabel = DESCRIPTION_LABEL;
        supplierLabel = SUPPLIER_LABEL;
        listPriceLabel = LISTPRICE_LABEL;
        salesPriceLabel = SALESPRICE_LABEL;
        deliveryDateLabel = DELIVERYDATE_LABEL;
        stockLabel = STOCK_LABEL;
        quantityLabel = QUANTITY_LABEL;
        fuelImage = FUEL;
        gripImage = GRIP;
        noiseImage = NOISE
        //Disable combobox selections
        @track showLabelFilter = false;
        @track showDimensionFilter = false;

        @track disabledHeigth = true;
        @track disabledInches = true;
        @track disabledCapacity = true;
        @track disabledSpeed = true;
        @track disabledGrip = true;
        @track disabledNoise = true;

        @track fuelOptions;
        @track gripOptions;
        @track noiseOptions;
        @track heightOptions = [];
        @track widthOptions;
        @track inchesOptions;
        @track capacityOptions;
        @track speedOptions;
        @track brandsOptions;
        @track isLoaded = true;

        @track searchResults = [];

        @track fuelValue;
        @track gripValue;
        @track noiseValue;
        @track heightValue;
        @track widthValue;
        @track inchesValue;
        @track capacityValue;
        @track speedValue;
        @track brandValue;
        @track seasonValue;
        userId = Id;
        searchTerm;
        // homologationTerm;
        effectiveAccount;

        get seasonOptions() {
            return [
                { label: 'All seasons', value: '' },
                { label: 'Summer', value: 'Summer' },
                { label: 'Winter', value: 'Winter' }
            ];
        }
//----------------------------------------------CONTROLLER----------------------------------------------------------//

    search(){
        this.isLoaded = !this.isLoaded;
        getSearchResults({Dim1: this.widthValue, Serie: this.heightValue, Dim3: this.inchesValue, capacity: this.capacityValue, speed: this.speedValue, searchTerm: this.searchTerm, brand: this.brandValue })
        .then((data) => {
            console.log('data : ',data);
            this.searchResults = JSON.parse(data);
            this.isLoaded = !this.isLoaded;
        })
            .catch((error) =>{
            console.log(error);
            this.isLoaded = !this.isLoaded;
        });
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
        this.userId = Id;
        console.log('this user : ',this.userId);
        getEffectiveAccount({userId: this.userId})
        .then((data) => {
            this.effectiveAccount = data;
            console.log('this.effectiveAccount : ',this.effectiveAccount);
        })
            .catch((error) =>{
            console.log(error);
        });
    }

    @wire(getBrands)
    getBrands(result){
        if(result.data){
            this.brandsOptions = [{ label: 'None', value: '', selected: true }, ...JSON.parse(JSON.stringify(result.data))];
        }else if(result.error){
            console.log(result.error);
        }
    }

    @wire(getWidths)
    getWidths(result) {
        if (result.data) {
            this.widthOptions = JSON.parse(JSON.stringify(result.data));
            console.log('width result',result);
            console.log('width result data',result.data);
            console.log('widthOptions : ', this.widthOptions);
        } else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getFuels)
    getFuels(result) {
        console.log('helloo1');
        if (result.data) {
            console.log('helloo2');
            this.fuelOptions = JSON.parse(JSON.stringify(result.data));
            console.log('width result',result);
            console.log('width result data',result.data);
            console.log('widthOptions : ', this.fuelOptions);
        } else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getVariations, { recordType: "Car" , UserId:"$userId"})
        getVariations(result) {
        if (result.data) {
            this.data = JSON.parse(JSON.stringify(result.data));
            var index = 0;

            for (let i = 0; i < this.data.length; i++) {
                this.data[i].wholesalers.sort((a, b) => a.SalesPrice - b.SalesPrice);
                var cheapest = this.data[i].wholesalers[0];
                var otherWholesalers = this.data[i].wholesalers.slice(1);
                this.data[i].wholesalers = otherWholesalers;
                this.data[i] = Object.assign(this.data[i],{cheapest:cheapest,showWholesalers:false,index:index,buttonLabel:'Show All'});

                index++;
            }
        } else if (result.error) {
                console.log(result.error);
        }
    }



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

    handleSearchTermChange(event){
        this.searchTerm = event.target.value;
    }

    handleSearchHomologationChange(event){
        this.homologationTerm = event.target.value;
    }

    handleAddToCart(event){
        let productId = event.target.dataset.id;
        let price = event.target.dataset.price;
        let quantity = event.target.dataset.orderquantity;
        let deliveryDate = event.target.dataset.deliverydate;
        console.log('productId : ',productId);
        addItemToCart({productId: productId, quantity: quantity, accountId: this.effectiveAccount, price: price, deliveryDate})
        .then((data) => {
            console.log('data : ',data);
        })
        .catch((error) =>{
        console.log(error);
        });
    }

    handleBrandChange(event){
        this.brandValue = event.detail.value;
    }

    handleSeasonChange(event){
        this.seasonValue = event.detail.value;
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
        }
        
    }
    //dimesions filter actions
    handleWidthChange(event){

        this.widthValue = event.detail.value;
        this.heightValue = null;
        this.inchesValue = null;
        this.capacityValue = null;
        this.speedValue = null;
        console.log('width : ',this.widthValue, 'height :',this.heightValue, 'inches :',this.inchesValue, 'capacity :',this.capacityValue, 'speed :',this.speedValue);
        this.disabledHeigth = false;
        this.disabledInches = true;
        this.disabledCapacity = true;
        this.disabledSpeed = true;
        getHeights({ width : this.widthValue})
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
        getInches({ height : this.heightValue , width : this.widthValue})
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
        getCapacities({ height : this.heightValue , width : this.widthValue, inches: this.inchesValue})
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
        getSpeeds({ height : this.heightValue , width : this.widthValue, inches: this.inchesValue, capacity:this.capacityValue})
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

    //labelling filters
    handleFuelChange(event){
        this.fuelValue = event.detail.value;
        this.gripValue = null;
        this.noiseValue = null;
        this.disabledGrip = false;
        this.disabledNoise = true;
        getGrips({ fuel : this.fuelValue})
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
        getNoises({ fuel : this.fuelValue, grip : this.gripValue})
        .then((data) => {
            this.noiseOptions = JSON.parse(JSON.stringify(data));
        })
        .catch((error) =>{
            console.log(error);
        })
    }
    
    handleNoiseChange(event){
        this.noiseValue = event.detail.value;
    }

//--------------------------------------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------------------------------------//

}