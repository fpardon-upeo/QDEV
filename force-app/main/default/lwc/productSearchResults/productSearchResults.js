/*
    Created by 
    ABDELHAFID KHRIBECH
    on 15/12/2022
*/

import { LightningElement } from 'lwc';
import CAR_LABEL from '@salesforce/label/c.B2BSearch_Car_Tab';
import TRUCK_LABEL from '@salesforce/label/c.B2BSearch_Truck_Tab';

export default class ProductSearchResults extends LightningElement {


    B2BSearch_Car_Tab = CAR_LABEL;
    B2BSearch_Truck_Tab = TRUCK_LABEL;

}