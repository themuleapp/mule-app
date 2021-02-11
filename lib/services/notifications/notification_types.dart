/**
 * This is a notification that gets sent to the mule when a user places a request
 * (Something is requested from the mule)
 */
const MULE_NEW_REQUEST = 'MULE_NEW_REQUEST';
/**
 * This is a notification that gets sent to the mule when a user confirms that they received the delivery.
 */
const MULE_DELIVERY_CONFIRMED = 'MULE_DELIVERY_CONFIRMED';
/**
 * This is a notification that gets sent to the user when a mule accepts his request.
 */
const USER_REQUEST_ACCEPTED = 'USER_REQUEST_ACCEPTED';
/**
 * This is a notification that gets sent to the user when a mule confirms that they had delivered the request.
 * When this is reqceived the user will get to see a button to confirm that he received the delivery.
 */
const USER_DELIVERED_CONFIRMED = 'USER_REQUEST_DELIVERED';
/**
 * This is a notification that gets sent to the user when the request he placed times out (no one accepted)
 */
const USER_REQUEST_TIMEOUT = 'USER_REQUEST_TIMEOUT';
