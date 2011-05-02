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
package com.ofnodesandedges.y2011.flash.loading{
	
	import com.ofnodesandedges.y2011.core.data.Graph;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class FileLoader extends EventDispatcher{
		
		public static const THRESHOLD:Number = 0.02;
		public static const FILE_PARSED:String = "File totally parsed";
		
		protected var _filePath:String;
		protected var _fileLoader:URLLoader;
		protected var _fileRequest:URLRequest;
		
		protected var _hasNodeCoordinates:int = 0;
		protected var _hasNodeSizes:int = 0;
		protected var _hasNodeColors:int = 0;
		
		public function FileLoader(){}
		
		public function openFile(filePath:String):void{
			_filePath = filePath;
			_fileRequest = new URLRequest(_filePath);
			_fileLoader = new URLLoader();
			
			configureListeners(_fileLoader);
			
			try {
				_fileLoader.load(_fileRequest);
			} catch (error:Error) {
				trace("FileLoader.openFile: Unable to load requested file.");
			}
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(event:Event):void{
			parseFile(event.target.data);
		}
		
		protected function parseFile(data:String):void{}
		
		private function openHandler(event:Event):void{
			trace("FileLoader.openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void{
			trace("FileLoader.progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void{
			trace("FileLoader.securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void{
			trace("FileLoader.httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void{
			trace("FileLoader.ioErrorHandler: " + event);
		}
	}
}