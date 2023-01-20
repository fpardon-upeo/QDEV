import { LightningElement,wire,track,api } from 'lwc';
import getVariations from "@salesforce/apex/ProductController.getVariations";
import getHeights from '@salesforce/apex/ProductController.getHeights';
import getWidths from '@salesforce/apex/ProductController.getWidths';
import getInches from '@salesforce/apex/ProductController.getInches';
import getCapacities from '@salesforce/apex/ProductController.getCapacities';
import getSpeeds from '@salesforce/apex/ProductController.getSpeeds';
import userId from "@salesforce/user/Id";

// const columns = [
//     { label: 'Brand', fieldName: 'Brand' },
//     { label: 'Dimension', fieldName: 'Dimension' },
//     { label: 'Brand / Profil', fieldName: 'BrandProfil' },
//     { label: 'Label', fieldName: 'Label'},
//     { label: 'Delivery Date', fieldName: 'DeliveryDate'},
//     { label: 'Stock', fieldName: 'Quantity' },
//     { label: 'List Price', fieldName: 'ListPrice',type:'currency' },
//     { label: 'Sales Price', fieldName: 'SalesPrice',type:'currency' },
//     { label: 'Order', fieldName: '' },
//     {label: 'Name', fieldName: 'AccountURL', type: 'url',
//     typeAttributes: {
//         label: {
//             fieldName: 'Name'
//         }
//     }
//}
// ];

export default class ProductResults extends LightningElement {
    @track data = [];
    @track value;

    @track showDimensionFilter = false;
    @track disabledHeigth = true;
    @track disabledInches = true;
    @track disabledCapacity = true;
    @track disabledSpeed = true;

    @track heightOptions = [];
    @track widthOptions;
    @track inchesOptions;
    @track capacityOptions;
    @track speedOptions;

    @track heightValue;
    @track widthValue;
    @track inchesValue;
    @track capacityValue;
    @track speedValue;
    // columns = columns;
    userId;
    @track queryTerm;
    @track searchButton = false;

    async connectedCallback() {
        this.userId = userId;
        console.log('this user : ',this.userId);
    }

    //press Enter in search input 
    // handleKeyUp(evt) {
    //     const isEnterKey = evt.keyCode === 13;
    //     if (isEnterKey) {
    //         this.queryTerm = evt.target.value;
    //     }
    // }




    //set combobox options
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

    handleSearchItemChange(event){
        this.queryTerm = event.target.value;
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
    

    // setup the variations to display it in the table
    handleSearchButton(event){
        console.log('queryTerm : ',this.queryTerm);
        
        console.log('search button');
        console.log('search button : ' , event);
        console.log('this query term :', this.queryTerm);
        getVariations({ recordType: "Car" , UserId:this.userId, width:this.widthValue, heigth:this.heightValue,inches:this.inchesValue,capacity:this.capacityValue,speed:this.speedValue,searchTerm:this.queryTerm})
        .then((data) => {
            // console.log('user id : ',this.userId);
            // console.log('json stringify : ',JSON.stringify(result));
            // console.log('json parsed : ',JSON.stringify(result.data));
            this.searchButton = true;
            this.data = JSON.parse(JSON.stringify(data));
            for (let i = 0; i < this.data.length; i++) {
                this.data[i].wholesalers.sort((a, b) => a.SalesPrice - b.SalesPrice);
                var cheapest = this.data[i].wholesalers[0];
                cheapest =  Object.assign(cheapest,{orderQuantity:false});
                var otherWholesalers = this.data[i].wholesalers.slice(1);
                this.data[i].wholesalers = otherWholesalers;
                this.data[i] = Object.assign(this.data[i],{cheapest:cheapest,showWholesalers:false,index:i,buttonLabel:'Show All',orderQuantity:false});
                for(let j = 0; j < this.data[i].wholesalers.length; j++){
                    this.data[i].wholesalers[j] =  Object.assign(this.data[i].wholesalers[j],{index:j,orderQuantity:false});
                }
                for(let j = 0; j < this.data[i].wholesalers.length; j++){
                    this.data[i].manufacturerLines[j] =  Object.assign(this.data[i].manufacturerLines[j],{index:j,orderQuantity:false});
                }
            }
        })
        .catch((error) =>{
            console.log('search error : ',error);
        })
            // console.log('this.data 1: ',JSON.stringify(this.data));

            // items.sort((a, b) => a.value - b.value);

            // console.log('this data  2: ',this.data);
        }
    //show all button to show all hide wholesalers
    showAll(event) {
        var index = event.target.dataset.id;
        // console.log('this index ', index);
        this.data[index].showWholesalers = !this.data[index].showWholesalers;
        this.data[index].buttonLabel = this.data[index].buttonLabel =='Show All' ?'Hide All':'Show All';
    }
    orderCheckbox(event){
        var manufacturerid = event.target.dataset.manufacturerid;
        var type = event.target.dataset.type;
        console.log(type)
        console.log(manufacturerid)
        var index;
        if(type != 'CheapestWholesaler'){
            index = event.target.dataset.id;
            console.log(index);
            if(type == 'manufacturerLine'){
                this.data[manufacturerid].manufacturerLines[index].orderQuantity = !this.data[manufacturerid].manufacturerLines[index].orderQuantity;
            }
            else if(type == 'wholesaler'){
                this.data[manufacturerid].wholesalers[index].orderQuantity = !this.data[manufacturerid].wholesalers[index].orderQuantity;
            }
            else if(type = 'manufacturer'){
                this.data[manufacturerid].orderQuantity = !this.data[manufacturerid].orderQuantity;
            }
        }
        else{
            this.data[manufacturerid].cheapest.orderQuantity = !this.data[manufacturerid].cheapest.orderQuantity;
        }
        
        
    }
}