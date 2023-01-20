import { api, LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';


export default class CartSummary extends LightningElement {
    /**
     * An event fired when the cart items change.
     * This event is a short term resolution to update any sibling component that may want to update their state based
     * on updates in the cart items.
     *
     * In future, if LMS channels are supported on communities, the LMS should be the preferred solution over pub-sub implementation of this example.
     * For more details, please see: https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.use_message_channel_considerations
     *
     * @event CartContents#cartitemsupdated
     * @type {CustomEvent}
     *
     * @export
     */

    /**
     * The pricing information for the cart summary's total.
     *
     * @typedef {Object} Prices
     *
     * @property {String} [originalPrice]
     *  The  list price aka "strikethrough" price (i.e. MSRP) of the cart.
     *  If the value is null, undefined, or empty, the list price will not be displayed.
     *
     * @property {String} finalPrice
     *   The final price of the cart.
     */

    /**
     * The recordId provided by the cart detail flexipage.
     *
     * @type {string}
     */
    @api
    recordId;

    /**
     * The effectiveAccountId provided by the cart detail flexipage.
     *
     * @type {string}
     */
    @api
    effectiveAccountId;

    /**
     * An object with the current PageReference.
     * This is needed for the pubsub library.
     *
     * @type {PageReference}
     */
    @wire(CurrentPageReference)
    pageRef;

    /**
     * This lifecycle hook fires when this component is inserted into the DOM.
     * We want to start listening for the 'cartitemsupdated'
     *
     * NOTE:
     * In future, if LMS channels are supported on communities, the LMS should be the preferred solution over pub-sub implementation of this example.
     * For more details, please see: https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.use_message_channel_considerations
     */
}