function Dsy() { this.Items = {}; }
Dsy.prototype.add = function(id,iArray) { this.Items[id] = iArray; } 
Dsy.prototype.Exists = function(id) { if(typeof(this.Items[id]) == "undefined") return false; return true; };
function change(v,aId){
	var str="0";
	var aTemp;
	if(aId==undefined){
			aId = s;
		}
	for(i=0;i<v;i++){  str+=("_"+(document.getElementById(aId[i]).selectedIndex-1))};
	var ss=document.getElementById(aId[v]);
	with(ss){
		length = 0;
		
		options[0]=new Option(opt0[v],opt0[v]);
		if(v && document.getElementById(aId[v-1]).selectedIndex>0 || !v)
		{
			if(dsy.Exists(str)){
				ar = dsy.Items[str];
				for(i=0;i<ar.length;i++)
				{
					aTemp = ar[i].split("|");
					options[length]=new Option(ar[i],ar[i]);
				}
				if(v)options[1].selected = true;
			}
		}
		if(++v<aId.length){change(v,aId);}
	}
}
var dsy = new Dsy();
dsy.add("0",["linux-3.5.4","android-2.6.29"]);
dsy.add("0_0",["arm","x86_64","i386"]);
dsy.add("0_1",["x86"]);
dsy.add("0_0_0",["virtual","real"]);
dsy.add("0_0_1",["virtual","real"]);
dsy.add("0_0_2",["virtual","real"]);
dsy.add("0_1_0",["virtual","real"]);

