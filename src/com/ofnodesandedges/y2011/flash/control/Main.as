package com.ofnodesandedges.y2011.flash.control{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.drawing.GraphDrawer;
	import com.ofnodesandedges.y2011.core.interaction.InteractionControler;
	import com.ofnodesandedges.y2011.core.layout.CircularLayout;
	import com.ofnodesandedges.y2011.core.layout.RotationLayout;
	import com.ofnodesandedges.y2011.core.layout.forceAtlas.ForceAtlas;
	import com.ofnodesandedges.y2011.flash.loading.FileLoader;
	import com.ofnodesandedges.y2011.flash.loading.LoaderGEXF;
	import com.ofnodesandedges.y2011.utils.ContentEvent;
	import com.ofnodesandedges.y2011.utils.FPSCounter;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Main extends Sprite{
		
		private var _fpsCounter:FPSCounter;
		
		public function Main(s:Stage){
			s.addChild(this);
			
			// Initialize the core controler:
			CoreControler.init(this,stage.stageWidth,stage.stageHeight);
			
			// Initialize the FPSCounter:
			_fpsCounter = FPSCounter(s.addChild(new FPSCounter(0xE0E0E0,0x000000,0xE0E0E0)));
			_fpsCounter.x = 5;
			_fpsCounter.y = 5;
			
			var filePath:String = "../graphs/erdos_clusters.gexf";
			var fileLoader:FileLoader;
			
			// Set file path:
			if(root.loaderInfo.parameters["filePath"]){
				filePath = root.loaderInfo.parameters["filePath"];
			}
			
			// Load the file:
			var fileExtension:String = filePath.substr(filePath.lastIndexOf('.')+1);
			
			switch(fileExtension.toLowerCase()){
				case "gexf":
					fileLoader = new LoaderGEXF();
					break;
				// TODO: More loaders.
			}
			
			fileLoader.addEventListener(FileLoader.FILE_PARSED,fileParsed);
			fileLoader.openFile(filePath);
		}
		
		private function fileParsed(e:Event):void{
			// Initialization sample:
			CircularLayout.apply(500,0,0);
			ForceAtlas.initAlgo();
			
			CoreControler.displayNodes = true;
			CoreControler.displayEdges = true;
			CoreControler.displayLabels = true;
			
			CoreControler.minDisplaySize = 1;
			CoreControler.maxDisplaySize = 5;
			CoreControler.textThreshold = 5;
			
			GraphDrawer.setEdgesColor(0x888888);
			GraphDrawer.setLabelsColor(0x444444);
			GraphDrawer.fontName = "Helvetica";
		}
	}
}