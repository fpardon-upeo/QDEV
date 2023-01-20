import { LightningElement } from 'lwc';

import QteamPNG from '@salesforce/resourceUrl/QTeamNewLogo';
import FbImageLink from '@salesforce/resourceUrl/FacebookIcon';
import YtbImageLink from '@salesforce/resourceUrl/YoutubeIcon';
import QTeamText from '@salesforce/label/c.B2B_Footer_QTeam_Text';
import Link1 from '@salesforce/label/c.B2B_Footer_Link_1';
import Link2 from '@salesforce/label/c.B2B_Footer_Link_2';
import Link3 from '@salesforce/label/c.B2B_Footer_Link_3';
import Link4 from '@salesforce/label/c.B2B_Footer_Link_4';
//import Link5 from '@salesforce/label/c.B2B_Footer_Link_5';
import URL1 from '@salesforce/label/c.B2B_Footer_Link_URL_1';
import URL2 from '@salesforce/label/c.B2B_Footer_Link_URL_2';
import URL3 from '@salesforce/label/c.B2B_Footer_Link_URL_3';
import URL4 from '@salesforce/label/c.B2B_Footer_Link_URL_4';
//import Link5 from '@salesforce/label/c.B2B_Footer_Link_URL_5';

export default class B2BFooter extends LightningElement {
    sfimage=QteamPNG;
    fbimage=FbImageLink;
    ytbimage=YtbImageLink;

    label = {
        QTeamText,
        Link1,
        Link2,
        Link3,
        Link4,
     //   Link5,
        URL1,
        URL2,
        URL3
    };

    submitrequest()
    {
        console.log('submitrequest');
    }


}