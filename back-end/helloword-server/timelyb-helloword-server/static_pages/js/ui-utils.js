/**
 * Created with PyCharm.
 * User: WORKSATION
 * Date: 16.11.13
 * Time: 9:04
 * To change this template use File | Settings | File Templates.
 */

$.fn.disableButton = function () {
    this.attr("disabled", "disabled");
};

$.fn.enableButton = function () {
    this.removeAttr("disabled");
};
