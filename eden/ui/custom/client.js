
var http_request = false;

var waitingOnResponse = false;

var currentIndex;
var currentGroup;

var hiddenElements = new Array();

function getRequestObject()
{
		http_request = false;

		if (window.XMLHttpRequest) { // Mozilla, Safari,...
				http_request = new XMLHttpRequest();
				if (http_request.overrideMimeType) {
						http_request.overrideMimeType('text/xml');
						// See note below about this line
				}
		} else if (window.ActiveXObject) { // IE
				try {
						http_request = new ActiveXObject("Msxml2.XMLHTTP");
				} catch (e) {
						try {
								http_request = new ActiveXObject("Microsoft.XMLHTTP");
						} catch (e) {}
				}
		}

		if (!http_request) {
				alert('Giving up :( Cannot create an XMLHTTP instance');
				return false;
		}
		http_request.onreadystatechange = updatePage;
		http_request.open('POST', '/', true);
		http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		
		return http_request;
}

function makeRequest(command) {

	var http_request = getRequestObject();

	if (!waitingOnResponse)
	{
		http_request.send(command);
		waitingOnResponse = true;
	}
}

function setRequest(index, group) {
	if (!waitingOnResponse)
	{
		currentIndex = index;
		currentGroup = group;
		makeRequest('set ' + index + ' ' + group);
	}	
}

function alertContents() {

		if (http_request.readyState == 4) {
				if (http_request.status == 200) {
						alert(http_request.responseText);
				} else {
						alert('There was a problem with the request.');
				}
		}

}

function updatePage()
{
	
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
			//alert(http_request.responseText);
			waitingOnResponse = false;
			if (http_request.responseText.match("set ok"))
			{	
				var i;
				groupChildren = document.getElementById(currentGroup + 'Container').childNodes;
				for (i = 0; i < groupChildren.length; i++)
				{
					if (groupChildren[i].tagName == 'A')
					{
						groupChildren[i].className = 'optionContainerUnselected';
					}
				} 
			
				document.getElementById(currentIndex + ' ' + currentGroup).className = 'optionContainerSelected';
			}
			else if (http_request.responseText.match("server terminated"))
			{
				var body = document.getElementById('bodyContainer');
				if (body)
				{
					var parent = body.parentNode;
					parent.removeChild(body);
					
					var quitMessage = document.createTextNode('You have safely quit the GhostUI configuration tool. You may close this window.');
					var quitParagraph = document.createElement('P');
					quitParagraph.className = 'exitMessage';
					quitParagraph.appendChild(quitMessage);
					parent.appendChild(quitParagraph);
				}
			}
			else
			{
				alert('An error occurred.');
			}
		} else {
			alert('There was a problem with the request.');
		}
	}

}

function hideOptionContents(group)
{
	var elem = document.getElementById(group + 'Container');
	
	if (elem)
	{
		var parent = elem.parentNode;
		hiddenElements[group + 'Container'] = elem;
		parent.removeChild(elem);		
	}
}

function showOptionContents(group)
{
	var parent = document.getElementById(group);
	
	if (parent && hiddenElements[group + 'Container'])
	{
		parent.insertBefore(hiddenElements[group + 'Container'],parent.childNodes[1]);
	}
}
