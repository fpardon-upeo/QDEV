import { LightningElement , wire} from 'lwc';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import LanguageLocaleKey_FIELD from '@salesforce/schema/User.LanguageLocaleKey';
import TypeofUser_FIELD from '@salesforce/schema/User.Type_of_User__c';
import CutOffTable_EN_D from '@salesforce/resourceUrl/CutOffTable_EN_D';
import CutOffTable_EN_P from '@salesforce/resourceUrl/CutOffTable_EN_P';
import CutOffTable_FR_D from '@salesforce/resourceUrl/CutOffTable_FR_D';
import CutOffTable_FR_P from '@salesforce/resourceUrl/CutOffTable_FR_P';
import CutOffTable_NE_D from '@salesforce/resourceUrl/CutOffTable_NE_D';
import CutOffTable_NE_P from '@salesforce/resourceUrl/CutOffTable_NE_P';

export default class CutoffTable extends LightningElement {

    userId = Id;
    languageLocaleKey;
    typeofUser;
    cutOffTable = '';

    @wire(getRecord, { recordId: Id, fields: [LanguageLocaleKey_FIELD, TypeofUser_FIELD]}) 
    userDetails({error, data}) {
        if (data) {
            this.languageLocaleKey = data.fields.LanguageLocaleKey.value;
            this.typeofUser = data.fields.Type_of_User__c.value;
            if(this.languageLocaleKey.includes("en")){
                if(this.typeofUser.includes("d")){
                    this.cutOffTable = CutOffTable_EN_D;
                } else{
                    this.cutOffTable = CutOffTable_EN_P;
                }
            } else if(this.languageLocaleKey.includes("fr")){
                if(this.typeofUser.includes("d")){
                    this.cutOffTable = CutOffTable_FR_D;
                } else{
                    this.cutOffTable = CutOffTable_FR_P;
                }
            } else{
                if(this.typeofUser.includes("d")){
                    this.cutOffTable = CutOffTable_NE_D;
                } else{
                    this.cutOffTable = CutOffTable_NE_P;
                }
            }
        } else if (error) {
            console.log(error);
        }
    }
}