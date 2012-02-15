var selected_style;
function replyhighlight(id){
	var tdtags=document.getElementsByTagName("td");
	var new_selected_style="reply";
	for(i=0; i<tdtags.length; i++){
		if(tdtags[i].className=="highlight"){
			tdtags[i].className=selected_style;
		}
		if(tdtags[i].id==id){
			new_selected_style=tdtags[i].className;
			tdtags[i].className="highlight";
		}
	}
	selected_style=new_selected_style;
}

function insert(text){
	var textarea=document.forms.postform.KOMENTO;
	if(!textarea) return;
	
	if(textarea.createTextRange && textarea.caretPos){
		var caretPos=textarea.caretPos;
		caretPos.text=caretPos.text.charAt(caretPos.text.length-1)==" "?text+" ":text;
	} else if(textarea.setSelectionRange){
		var start=textarea.selectionStart;
		var end=textarea.selectionEnd;
		textarea.value=textarea.value.substr(0,start)+text+textarea.value.substr(end);
		textarea.setSelectionRange(start+text.length,start+text.length);
	} else{
		textarea.value+=text+" ";
	}
	textarea.focus();
}

function get_cookie(name){
	with(document.cookie){
		var regexp=new RegExp("(^|;\\s+)"+name+"=(.*?)(;|$)");
		var hit=regexp.exec(document.cookie);
		if(hit&&hit.length>2) return decodeURIComponent(hit[2]);
		else return '';
	}
};

function toggle(id){
	var elem;
	
	if(!(elem=document.getElementById(id))) return;

	elem.style.display=elem.style.display?"":"none";
}

function who_are_you_quoting(e) {
	var clr, src, cnt;
	
	e = e.target || window.event.srcElement;
	
	cnt = document.createElement('div');
	cnt.id = 'q-p';
	
	src = document.getElementById(e.getAttribute('href').replace('#','')).cloneNode(true);
	src.id = 'q-p-s';
	if (src.tagName == 'DIV') {
		src.setAttribute('class', 'q-p-op');
		clr = document.createElement('div');
		clr.setAttribute('class', 'newthr');
		src.appendChild(clr);
	}
	
	cnt.appendChild(src);
	e.parentNode.insertBefore(cnt, e.nextSibling);
}

function remove_quote_preview(e) {
	var cnt = document.getElementById('q-p');
	
	if (cnt) {
        (e.target || window.event.srcElement).parentNode.removeChild(cnt);
	}
}

window.onload=function(){
	var i, j, quotes, arr = location.href.split(/#/);
	
	if(arr[1]) 
		replyhighlight(arr[1]);
	
	if(document.forms.postform && document.forms.postform.NAMAE)
		document.forms.postform.NAMAE.value=get_cookie("name");
	
	if(document.forms.postform && document.forms.postform.MERU)
		document.forms.postform.MERU.value=get_cookie("email");

	if(document.forms.postform && document.forms.postform.delpass)
		document.forms.postform.delpass.value=get_cookie("delpass");
	
	quotes = document.getElementsByName('backlink');
	if (document.addEventListener) {
		for (i = 0, j = quotes.length; i < j; ++i) {
			quotes[i].addEventListener('mouseover', who_are_you_quoting, false);
			quotes[i].addEventListener('mouseout', remove_quote_preview, false);
		}
	} else if (document.attachEvent) {
		for (i = 0, j = quotes.length; i < j; ++i) {
			quotes[i].attachEvent('onmouseover', who_are_you_quoting);
			quotes[i].attachEvent('onmouseout', remove_quote_preview);
		}
	}
}

