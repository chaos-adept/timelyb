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

Number.prototype.leftZeroPad = function(numZeros) {
	var n = Math.abs(this);
	var zeros = Math.max(0, numZeros - n.toString().length );
	var zeroString = Math.pow(10,zeros).toString().substr(1);
	if( this < 0 ) {
		zeroString = '-' + zeroString;
	}

	return zeroString+n;
}

function millisecondsToTime(ms)
{
    var secs = Math.floor(ms / 1000);
    var msleft = ms % 1000;
    var hours = Math.floor(secs / (60 * 60));
    var divisor_for_minutes = secs % (60 * 60);
    var minutes = Math.floor(divisor_for_minutes / 60);
    var divisor_for_seconds = divisor_for_minutes % 60;
    var seconds = Math.ceil(divisor_for_seconds);
    return hours.leftZeroPad(2) + ":" + minutes.leftZeroPad(2)

}


function notifyRequestStarted() {
    $('.progress-indicator').css( 'display', 'block' );
}

function notifyRequestCompleted() {
    $('.progress-indicator').css( 'display', 'none' );
}

