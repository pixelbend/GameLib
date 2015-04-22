package com.pixelBender.facade
{
	public class LogicXML
	{
		private var xml:XML;
		public function LogicXML()
		{
			xml = <logic>
						<components>
							<component type="gameComponent" 	name="_game__componentProxy"					className="com.pixelBender.model.GameComponentProxy" />
							<component type="gameComponent" 	name="_game__assetProxy" 						className="com.pixelBender.model.AssetProxy" />
							<component type="gameComponent" 	name="_game__soundProxy" 						className="com.pixelBender.model.SoundProxy" />
							<component type="gameComponent" 	name="_game__localizationProxy"					className="com.pixelBender.model.LocalizationProxy" />
							<component type="gameComponent" 	name="_game__fileReferenceProxy"				className="com.pixelBender.model.FileReferenceProxy" />
							<component type="gameComponent" 	name="_game__tweenProxy"						className="com.pixelBender.model.TweenProxy" />
							<component type="gameComponent" 	name="_game__gameScreenManagerMediator"			className="com.pixelBender.view.gameScreen.GameScreenManagerMediator" />
							<component type="gameComponent" 	name="_game__popupManagerMediator"				className="com.pixelBender.view.popup.PopupManagerMediator" />
							<component type="asset" 			name="swf" 										className="com.pixelBender.model.vo.asset.SWFAssetVO" />
							<component type="asset" 			name="image"									className="com.pixelBender.model.vo.asset.ImageAssetVO" />
							<component type="asset"			    name="xml" 										className="com.pixelBender.model.vo.asset.XMLAssetVO" />
							<component type="asset"			    name="sound" 									className="com.pixelBender.model.vo.asset.SoundAssetVO" />
							<component type="assetLoader"		name="swf" 										className="com.pixelBender.model.component.loader.SWFLoader" />
							<component type="assetLoader"		name="image" 									className="com.pixelBender.model.component.loader.ImageLoader" />
							<component type="assetLoader"		name="xml" 										className="com.pixelBender.model.component.loader.XMLLoader" />
							<component type="assetLoader"		name="sound" 									className="com.pixelBender.model.component.loader.SoundLoader" />
						</components>
						<gameComponents>
							<gameComponent name="_game__componentProxy" 					type="proxy" />
							<gameComponent name="_game__assetProxy" 						type="proxy" />
							<gameComponent name="_game__soundProxy" 						type="proxy" />
							<gameComponent name="_game__localizationProxy" 					type="proxy" />
							<gameComponent name="_game__fileReferenceProxy" 				type="proxy" />
							<gameComponent name="_game__tweenProxy" 						type="proxy" />
							<gameComponent name="_game__gameScreenManagerMediator" 			type="mediator" />
							<gameComponent name="_game__popupManagerMediator" 				type="mediator" />
						</gameComponents>
						<transitions>
							<transition name="loopTransition" 	className="com.pixelBender.view.transition.LoopTransition" />
						</transitions>
						<transitionSequences>
							<transitionSequence name="defaultTransitionSequence">
								<transition name="loopTransition"/>
								<transition name="loopTransition"/>
								<transition name="loopTransition"/>
							</transitionSequence>
						</transitionSequences>
					</logic>;
		}
		public function getXML():XML {return xml;}
	}
}