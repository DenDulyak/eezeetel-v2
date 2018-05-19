function CheckNumbers(input_text, skip_chars) {
    if (IsNULL(input_text)) return false;

    var retVal = true;

    for (var i = 0; i < input_text.length; i++)
        if (input_text.charAt(i) < '0' || input_text.charAt(i) > '9') {
            retVal = false;

            if (skip_chars != null) {
                for (var j = 0; j < skip_chars.length; j++) {
                    if (input_text.charAt(i) == skip_chars.charAt(j)) {
                        retVal = true;
                        break;
                    }
                }
            }

            if (!retVal) break;

            retVal = true;
        }

    return retVal;
}

function getHttpObject() {
    var xmlHttp;

    try {  // Firefox, Opera 8.0+, Safari
        xmlHttp = new XMLHttpRequest();
    }
    catch (e) {  // Internet Explorer
        try {
            xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e) {
            try {
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (e) {
            }
        }
    }

    return xmlHttp;
}

function CheckCharacters(input_text, skip_chars) {
    if (IsNULL(input_text)) return false;

    var retVal = true;

    for (var i = 0; i < input_text.length; i++)
        if ((input_text.charAt(i) < 'a' || input_text.charAt(i) > 'z') && (input_text.charAt(i) < 'A' || input_text.charAt(i) > 'Z')) {
            retVal = false;

            if (skip_chars != null) {
                for (var j = 0; j < skip_chars.length; j++) {
                    if (input_text.charAt(i) == skip_chars.charAt(j)) {
                        retVal = true;
                        break;
                    }
                }
            }

            if (!retVal) break;
        }

    return retVal;
}

function AlphaNumerals(input_text) {
    for (var i = 0; i < input_text.length; i++)
        if ((input_text.charAt(i) < 'a' || input_text.charAt(i) > 'z') && (input_text.charAt(i) < 'A' || input_text.charAt(i) > 'Z')
            && (input_text.charAt(i) < '0' || input_text.charAt(i) > '9'))
            return false;

    return true;
}

function CheckSpecialCharacters(input_text, skip_chars) {
    if (IsNULL(input_text)) return false;

    var retVal = true;

    for (var i = 0; i < input_text.length; i++) {
        if ((input_text.charAt(i) >= ' ' && input_text.charAt(i) < '0') ||
            (input_text.charAt(i) > '9' && input_text.charAt(i) < 'A') ||
            (input_text.charAt(i) > 'Z' && input_text.charAt(i) < 'a') ||
            (input_text.charAt(i) > 'z' && input_text.charAt(i) <= '~')) {
            retVal = false;

            if (skip_chars != null) {
                for (var j = 0; j < skip_chars.length; j++) {
                    if (input_text.charAt(i) == skip_chars.charAt(j)) {
                        retVal = true;
                        break;
                    }
                }
            }

            if (!retVal) break;
        }
    }

    return retVal;
}

function CheckDatabaseChars(input_field) {
    var retVal = true;

    if (!IsNULL(input_field.value)) {
        input_field.value = input_field.value.replace("\'", "\\\'");
        input_field.value = input_field.value.replace("\"", "\\\"");
        input_field.value = input_field.value.replace(",", "\\,");
    }

    return retVal;
}

function HasSpaces(input_text) {
    for (var i = 0; i < input_text.length; i++)
        if (input_text.charAt(i) == ' ' || input_text.charAt(i) == '\t' || input_text.charAt(i) == '\r')
            return true;

    return false;
}

function IsNULL(input_text) {
    if (input_text == null || input_text.length == 0)
        return true;
    else
        return false;
}

function getShortNameMonth(month_id) {
    var month = "";
    if (month_id < 0 || month_id > 11) return month;

    switch (month_id) {
        case 0:
            month = 'jan';
            break;
        case 1:
            month = 'feb';
            break;
        case 2:
            month = 'mar';
            break;
        case 3:
            month = 'apr';
            break;
        case 4:
            month = 'may';
            break;
        case 5:
            month = 'jun';
            break;
        case 6:
            month = 'jul';
            break;
        case 7:
            month = 'aug';
            break;
        case 8:
            month = 'sep';
            break;
        case 9:
            month = 'oct';
            break;
        case 10:
            month = 'nov';
            break;
        case 11:
            month = 'dec';
            break;
    }

    return month;
}

function getMonthNumber(month_name) {
    var nMonth = -1;

    var month = "";
    if (!IsNULL(month_name))
        month = month_name.toLowerCase();
    else
        return nMonth;

    if (month == 'jan') nMonth = 0;
    if (month == 'feb') nMonth = 1;
    if (month == 'mar') nMonth = 2;
    if (month == 'apr') nMonth = 3;
    if (month == 'may') nMonth = 4;
    if (month == 'jun') nMonth = 5;
    if (month == 'jul') nMonth = 6;
    if (month == 'aug') nMonth = 7;
    if (month == 'sep') nMonth = 8;
    if (month == 'oct') nMonth = 9;
    if (month == 'nov') nMonth = 10;
    if (month == 'dec') nMonth = 11;

    return nMonth;
}

function CheckDate(input_text) {
    if (IsNULL(input_text)) return false;
    var temp = new Array();
    temp = input_text.split('-');
    if (IsNULL(temp[0])) return false;
    if (IsNULL(temp[1])) return false;
    if (IsNULL(temp[2])) return false;

    var nMonth = 0;
    nMonth = getMonthNumber(temp[1]);

    if (nMonth < 0) return false;

    var dt = new Date(temp[2], nMonth, temp[0]);

    if (dt.getFullYear() != temp[2])
        return false;

    if (dt.getMonth() != nMonth)
        return false;

    if (dt.getDate() != temp[0])
        return false;

    return true;
}

function CheckPhoneNumber(input_text) {
    if (IsNULL(input_text)) return false;
    if (input_text.charAt(0) == '+')
        return CheckNumbers(input_text);
    else
        return CheckNumbers(input_text);

}

function SubmitForm(action_page, check_selection) {
    if (check_selection == false) {
        document.the_form.action = action_page;

        document.the_form.submit();
        return 1;
    }

    if (document.the_form.record_id != null) {
        var nItems = document.the_form.record_id.length;
        if (nItems == null || nItems <= 0) {
            if (document.the_form.record_id.checked) {
                document.the_form.action = action_page;
                document.the_form.submit();
                return 1;
            } else
                alert("Please select a record to perform the operation.");
        } else {
            for (var i = 0; i < document.the_form.record_id.length; i++)
                if (document.the_form.record_id[i].checked) {
                    document.the_form.action = action_page;
                    ;
                    document.the_form.submit();
                    return 1;
                }

            alert("Please select a record to perform the operation.");
        }
    } else
        alert("No records available to perform the operation.");
}
