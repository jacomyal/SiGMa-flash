package com.ofnodesandedges.y2011.flash.control{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.layout.forceAtlas.ForceAtlas;
	import com.ofnodesandedges.y2011.flash.loading.FileLoader;
	import com.ofnodesandedges.y2011.flash.loading.LoaderGEXF;
	import com.ofnodesandedges.y2011.utils.FPSCounter;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Main extends Sprite{
		
		private var _fpsCounter:FPSCounter;
		
		public function Main(s:Stage){
			s.addChild(this);
			CoreControler.init(this,stage.stageWidth,stage.stageHeight);
			
			ForceAtlas.initAlgo();
			
			_fpsCounter = FPSCounter(s.addChild(new FPSCounter(0xFFE0E0,0x800000,0xFFE0E0)));
			_fpsCounter.x = 5;
			_fpsCounter.y = 5;
			
			var filePath:String = "../graphs/les_miserables.gexf";
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
			}
			
			fileLoader.openFile(filePath);
		}
	}
}