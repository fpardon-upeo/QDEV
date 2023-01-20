import { LightningElement, wire, api, track } from 'lwc';

export default class B2bleCartSwitcher extends LightningElement {
    @api effectiveAccountId;
    @api cartTypes;

    @track carts = [];

    @track showDeleteModal = false;
    @track showCreateModal = false;

}