/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.tools = (function() {
    "use strict";

    var //functions
        removeFromArray,
        ucFirst,
        getRadioVal,
        lz,
        stringToDate,
        dedupeArray,
        monthToNum,
        isDate,
        isValidDate,
        validMonth,
        jsError,
        getQueryVar,
        getTextFieldValue,
        getI18nText
        ;

    removeFromArray = function( arr, item ) {
        var i;

        for( i = arr.length; i >= 0; i-- ) {
            if( arr[ i ] === item ) {
                arr.splice( i, 1 );
            }
        }

        return arr;
    };

    ucFirst = function( str ) {
        var f;

        str += '';
        f = str.charAt( 0 ).toUpperCase();
        return f + str.substr( 1 );
    };

    getRadioVal = function( $el ) {
        var radioVal = 'unchecked',
            x;

        for( x = 0; x < $el.length; x++ ) {
            if( $( $el[ x ] ).is( ':checked' ) ) {
                radioVal = $( $el[ x ] ).val();
            }
        }

        return radioVal;
    };

    getTextFieldValue = function(field){
        var item = $(field).length,
            value = $(field).val();

        if(item){
            if(value !== '' ) {
                return value;
            } else {
                return '';
            }
        } else {
            return '';
        }
    };

    lz = function( n ) {
        return ( parseInt( n, 10 ) > 0  && parseInt( n, 10 ) < 10 ? '0' + n.toString() : n );
    };

    stringToDate = function( str ) {
        // expects string in format YYYY-MM-DD
        // returns date as number of ms
        var d = new Date( str.split( '-' )[ 0 ], str.split( '-' )[ 1 ], str.split( '-' )[ 2 ], 0, 0, 0, 0 );
        return d.getTime();
    };

    dedupeArray = function( arr ) {
        var i,
            len = arr.length,
            out = [],
            obj = {};

        for ( i = 0; i < len; i++ ) {
            obj[ arr[ i ] ] = 0;
        }
        for ( i in obj ) {
            if( obj.hasOwnProperty( i ) ) {
                out.push( i );
            }
        }
        return out;
    };

    isDate = function( d, m, y ) {
        var monthno = validMonth(m);
        if (monthno === false) {
            monthno = monthToNum(m);
        }
        if (monthno !== false) {
            var monthno_str = monthno.toString(10);
            var pad = "00";
            var padded_monthno_str = pad.substring(0, pad.length - monthno_str.length) + monthno_str;
            return isValidDate( y + '-' + padded_monthno_str + '-' + d );
        }
        return false;
    };

    monthToNum = function( str ) {
        var months = [
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December'
            ],
            x;

        for( x = 0; x < months.length; x++ ) {
            if( str.substr( 0, 3 ).toLowerCase() === months[ x ].substr( 0, 3 ).toLowerCase() ) {
                return x + 1;
            }
        }

        return false;
    };

    validMonth = function( m ) {
        if( !isNaN( m ) && parseInt( m, 10) >= 1 && parseInt( m, 10) <= 12 ) {
            return m;
        }
        if( isNaN( m ) ) {
            return monthToNum( m );
        }

        return false;
    };

    isValidDate = function ( str ) {
        var split = str.split( '-' ),
            d = new Date( split[0], split[1]-1, split[2] );

        if ( Object.prototype.toString.call( d ) !== "[object Date]" ) {
            return false;
        }
        return !isNaN( d.getTime() );
    };

    getQueryVar = function( q ) {
        var str = decodeURIComponent( window.location.search ).substr( 1 ),
            arr = str.split( '&' ),
            x,
            item;


        for( x = 0; x < arr.length; x++ ) {
            item = arr[x];
            if( item.split( '=' )[ 0 ] === q ) {
                return item.split( '=' )[ 1 ];
            }
        }
        return false;
    };

    getI18nText = function( label ) {
        var locale = getQueryVar('locale');
        return eval('moj.Modules.' + label + '.' + locale);
    };

    return {
        removeFromArray: removeFromArray,
        ucFirst: ucFirst,
        getRadioVal: getRadioVal,
        lz: lz,
        stringToDate: stringToDate,
        dedupeArray: dedupeArray,
        isDate: isDate,
        validMonth: validMonth,
        jsError: jsError,
        getQueryVar: getQueryVar,
        getI18nText: getI18nText
    };

}());
