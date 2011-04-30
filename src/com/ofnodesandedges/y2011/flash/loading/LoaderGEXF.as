package com.ofnodesandedges.y2011.flash.loading{
	
	import com.ofnodesandedges.y2011.core.data.Edge;
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.core.drawing.EdgeDrawer;
	import com.ofnodesandedges.y2011.core.drawing.NodeDrawer;
	
	import flash.events.Event;
	
	public class LoaderGEXF extends FileLoader{
		
		public function LoaderGEXF(){}
		
		protected override function parseFile(data:String):void{
			var xml:XML = new XML(data);
			
			var xmlRoot:XMLList = xml.elements();
			var xmlMeta:XMLList;
			var xmlGraph:XMLList;
			var xmlGraphAttributes:XMLList;
			var xmlNodes:XMLList;
			var xmlEdges:XMLList;
			var xmlNodesAttributes:XMLList;
			var xmlEdgesAttributes:XMLList;
			
			var xmlCursor:XML;
			
			// Parse at depth:=1:
			for(var i:int=0;i<xmlRoot.length();i++){
				if(xmlRoot[i].name().localName=='meta'){
					xmlMeta = xmlRoot[i].children();
				}else if(xmlRoot[i].name().localName=='graph'){
					xmlGraph = xmlRoot[i].children();
					xmlGraphAttributes = xmlRoot[i].attributes();
				}
			}
			
			// Parse graph attributes
			for(i=0;i<xmlGraphAttributes.length();i++){
				trace(xmlGraphAttributes[i].name().localName+":");
				trace("\t\""+xmlGraphAttributes[i].valueOf()+"\"");
				if(xmlGraphAttributes[i].name().localName=='defaultedgetype'){
					switch(xmlGraphAttributes[i].valueOf().toString()){
						case "undirected":
							Graph.defaultEdgeType = EdgeDrawer.LINE;
							break;
						case "directed":
							Graph.defaultEdgeType = EdgeDrawer.CURVE;
							break;
						case "arrows":
							Graph.defaultEdgeType = EdgeDrawer.ARROW;
							break;
						default:
							break;
					}
				}
			}
			
			// Parse at depth:=2:
			for(i=0;i<xmlGraph.length();i++){
				if((xmlGraph[i].name().localName=='attributes')&&(xmlGraph[i].attribute("class")=='node')){
					xmlNodesAttributes = xmlGraph[i].children();
				}else if((xmlGraph[i].name().localName=='attributes')&&(xmlGraph[i].attribute("class")=='edge')){
					xmlEdgesAttributes = xmlGraph[i].children();
				}else if(xmlGraph[i].name().localName=='nodes'){
					xmlNodes = xmlGraph[i].children();
				}else if(xmlGraph[i].name().localName=='edges'){
					xmlEdges = xmlGraph[i].children();
				}
			}
			
			// Now we can easily parse all metadata...
			if(xmlMeta!=null){
				for each(xmlCursor in xmlMeta){
					Graph.addMetaData(xmlCursor.name().localName,xmlCursor.text());
				}
			}
			
			// ..., node attributes...
			var attId:String;
			var attTitle:String;
			var attType:String;
			var attDefault:*;
			
			if(xmlNodesAttributes!=null){
				var nodeAttributesCounter:int = 0;
				for each(xmlCursor in xmlNodesAttributes){
					if(xmlCursor.name().localName=="attribute"){
						attId = (xmlCursor.@id!=undefined) ? xmlCursor.@id : null;
						attTitle = (xmlCursor.@title!=undefined) ? xmlCursor.@title : null;
						attType = (xmlCursor.@type!=undefined) ? xmlCursor.@type : "String";
						attDefault = null;
						
						for each(xmlSubCursor in xmlCursor.children()){
							// Position:
							if(xmlSubCursor.name().localName=='default'){
								attDefault = setDefaultVar(xmlSubCursor.text(),attType);
							}
						}
						
						if((attId!=null)&&(attTitle!=null)){
							Graph.addNodeAttribute(attId,attTitle,attType,attDefault);
							nodeAttributesCounter++;
						}
					}
				}
			}
			
			// ..., edge attributes...
			if(xmlEdgesAttributes!=null){
				var edgeAttributesCounter:int = 0;
				for each(xmlCursor in xmlEdgesAttributes){
					if(xmlCursor.name().localName=="attribute"){
						attId = (xmlCursor.@id!=undefined) ? xmlCursor.@id : null;
						attTitle = (xmlCursor.@title!=undefined) ? xmlCursor.@title : null;
						attId = (xmlCursor.@type!=undefined) ? xmlCursor.@type : "String";
						attDefault = null;
						
						for each(xmlSubCursor in xmlCursor.children()){
							// Position:
							if(xmlSubCursor.name().localName=='default'){
								attDefault = setDefaultVar(xmlSubCursor.text(),attType);
							}
						}
						
						if((attId!=null)&&(attTitle!=null)){
							Graph.addEdgeAttribute(attId,attTitle,attType,attDefault);
							edgeAttributesCounter++;
						}
					}
				}
			}
			
			// ..., nodes...
			var nodesCounter:int = 0;
			var node:Node;
			var xmlSubCursor:XML;
			var xmlNodesAttributesValues:XMLList;
			
			var x:Number;
			var y:Number;
			
			var size:Number;
			var shape:String;
			var b:String;
			var g:String;
			var r:String;
			
			var id:String;
			var label:String;
			
			for each(xmlCursor in xmlNodes){
				label = (xmlCursor.@label!=undefined) ? xmlCursor.@label : null;
				id = (xmlCursor.@id!=undefined) ? xmlCursor.@id : nodesCounter.toString();
				
				node = new Node(id,label);
				
				xmlNodesAttributesValues = null;
				
				for each(xmlSubCursor in xmlCursor.children()){
					// Position:
					if(xmlSubCursor.name().localName=='position'){
						if((xmlSubCursor.attribute("x")!=undefined)&&
						   (xmlSubCursor.attribute("y")!=undefined)){
							x = new Number(xmlSubCursor.attribute("x"));
							y = new Number(xmlSubCursor.attribute("y"));
							
							node.x = x;
							node.y = -y;
						}else{
							_hasNodeCoordinates++;
						}
					}
					
					// Color:
					if(xmlSubCursor.name().localName=='color'){
						if((xmlSubCursor.attribute("b")!=undefined)&&
						   (xmlSubCursor.attribute("g")!=undefined)&&
						   (xmlSubCursor.attribute("r")!=undefined)){
							b = xmlSubCursor.attribute("b");
							g = xmlSubCursor.attribute("g");
							r = xmlSubCursor.attribute("r");
							
							node.color = setColor(b,g,r);
						}else{
							_hasNodeColors++;
						}
					}
					
					// Size:
					if(xmlSubCursor.name().localName=='size'){
						if(xmlSubCursor.@value!=undefined){
							size = new Number(xmlSubCursor.@value);
							node.size = size;
						}else{
							_hasNodeSizes++;
						}
					}
					
					// Shape:
					if(xmlSubCursor.name().localName=='shape'){
						if(xmlSubCursor.@value!=undefined){
							shape = xmlSubCursor.@value;
							switch(shape){
								case "disc":
									node.shape = 0;
									break;
								case "triangle":
									node.shape = 3;
									break;
								case "square":
									node.shape = 4;
									break;
								case "pentagon":
									node.shape = 5;
									break;
								case "hexagon":
									node.shape = 6;
									break;
								default:
									node.shape = NodeDrawer.NONE;
									break;
							}
						}
					}
					
					// Old format attributes container, see below:
					if(xmlSubCursor.name().localName=='attvalues'){
						xmlNodesAttributesValues = xmlSubCursor.children();
					}
					
					// New format attributes:
					if(xmlSubCursor.name().localName=='attvalue'){
						if((xmlSubCursor.attribute("for")!=undefined)&&(xmlSubCursor.@value!=undefined)){
							node.attributes[xmlSubCursor.attribute("for")] = xmlSubCursor.@value;
						}else if((xmlSubCursor.@id!=undefined)&&(xmlSubCursor.@value!=undefined)){
							node.attributes[xmlSubCursor.@id] = xmlSubCursor.@value;
						}
					}
				}
				
				// Old format attributes:
				for each(xmlSubCursor in xmlNodesAttributesValues){
					if(xmlSubCursor.name().localName=='attvalue'){
						if((xmlSubCursor.attribute("for")!=undefined)&&(xmlSubCursor.@value!=undefined)){
							node.attributes[xmlSubCursor.attribute("for")] = xmlSubCursor.@value;
						}else if((xmlSubCursor.@id!=undefined)&&(xmlSubCursor.@value!=undefined)){
							node.attributes[xmlSubCursor.@id] = xmlSubCursor.@value;
						}
					}
				}
				
				Graph.addNode(node);
				nodesCounter++;
			}
			
			// ... and edges:
			var edge:Edge;
			var edgesCounter:int = 0;
			var edgeAttributes:Object;
			var xmlEdgesAttributesValues:XMLList;
			
			for each(xmlCursor in xmlEdges){
				id = (xmlCursor.@id!=undefined) ? xmlCursor.@id : edgesCounter.toString();
				
				if(!(edgesCounter%100)) trace("New edge: "+edgesCounter);
				if(xmlCursor.@source!=xmlCursor.@target){
					xmlEdgesAttributesValues = new XMLList();
					edgeAttributes = new Object();
					
					for each(xmlSubCursor in xmlCursor.children()){
						if(xmlSubCursor.name().localName=='attvalues'){
							xmlEdgesAttributesValues = xmlSubCursor.children();
						}
					}
					
					for each(xmlSubCursor in xmlEdgesAttributesValues){
						if(xmlSubCursor.name().localName=='attvalue'){
							if((xmlSubCursor.attribute("for")!=undefined)&&(xmlSubCursor.@value!=undefined)){
								edgeAttributes[xmlSubCursor.attribute("for")] = xmlSubCursor.@value;
							}else if((xmlSubCursor.@id!=undefined)&&(xmlSubCursor.@value!=undefined)){
								edgeAttributes[xmlSubCursor.@id] = xmlSubCursor.@value;
							}
						}
					}
					
					edge = new Edge(id,xmlCursor.@source,xmlCursor.@target);
					edge.type = edgeAttributes["edgeType"] ? edgeAttributes["edgeType"] : EdgeDrawer.NONE;
					
					Graph.addEdge(edge);
					
					edgesCounter++;
				}
			}
			
			dispatchEvent(new Event(FILE_PARSED));
		}
		
		private function setColor(B:String,G:String,R:String):uint{
			var tempColor:String ="0x"+decaToHexa(R)+decaToHexa(G)+decaToHexa(B);
			return new uint(tempColor);
		}
		
		/**
		 * Transforms a decimal value (int formated) into an hexadecimal value.
		 * Is only useful with the other function, decaToHexa.
		 * 
		 * @param d int formated decimal value
		 * @return Hexadecimal string translation of d
		 * 
		 * @author Ammon Lauritzen
		 * @see http://goflashgo.wordpress.com/
		 * @see #decaToHexa
		 */
		private function decaToHexaFromInt(d:int):String{
			var c:Array = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
			if(d>255) d = 255;
			var l:int = d/16;
			var r:int = d%16;
			return c[l]+c[r];
		}
		
		/**
		 * Transforms a decimal value (string formated) into an hexadecimal value.
		 * Really helpfull to adapt the RGB gexf color format in AS3 uint format.
		 * 
		 * @param dec String formated decimal value
		 * @return Hexadecimal string translation of dec
		 * 
		 * @author Ammon Lauritzen
		 * @see http://goflashgo.wordpress.com/
		 */
		private function decaToHexa(dec:String):String {
			var hex:String = "";
			var bytes:Array = dec.split(" ");
			for( var i:int = 0; i <bytes.length; i++ )
				hex += decaToHexaFromInt( int(bytes[i]) );
			return hex;
		}
		
		private function setDefaultVar(defaultValue:String,type:String):*{
			var res:*;
			
			switch(type.toLowerCase()){
				case 'float':
				case 'long':
				case 'double':
					res = new Number(defaultValue);
					break;
				case 'int':
				case 'integer':
					res = new int(defaultValue);
					break;
				default:
					res = defaultValue;
					break;
			}
			
			return res;
		}
		
	}
}