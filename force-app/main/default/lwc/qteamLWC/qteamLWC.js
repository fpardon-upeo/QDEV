import { LightningElement } from 'lwc';

import QteamPNG from '@salesforce/resourceUrl/QteamPNG';
import FbImageLink from '@salesforce/resourceUrl/FbImageLink';
import YtbImageLink from '@salesforce/resourceUrl/YtbImageLink';

export default class QteamLWC extends LightningElement {
    sfimage=QteamPNG;
    fbimage=FbImageLink;
    ytbimage=YtbImageLink;


    submitrequest()
    {
        console.log('submitrequest');
    }


}