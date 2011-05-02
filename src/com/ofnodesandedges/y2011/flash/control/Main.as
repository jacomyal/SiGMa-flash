/**
 * SiGMa-flash
 * Copyright (C) 2011 by Alexis Jacomy
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
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
			_fpsCounter.x = stage.stageWidth-_fpsCounter.width;
			_fpsCounter.y = stage.stageHeight-_fpsCounter.height;
			
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
				// TODO: More loaders.
			}
			
			stage.addEventListener(Event.RESIZE,resize);
			fileLoader.addEventListener(FileLoader.FILE_PARSED,fileParsed);
			fileLoader.openFile(filePath);
		}
		
		private function resize(e:Event):void{
			_fpsCounter.x = stage.stageWidth-_fpsCounter.width;
			_fpsCounter.y = stage.stageHeight-_fpsCounter.height;
			
			CoreControler.resize(stage.stageWidth,stage.stageHeight);
		}
		
		private function fileParsed(e:Event):void{
			// Initialization sample:
			CircularLayout.apply(500,0,0);
			//ForceAtlas.initAlgo();
			
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