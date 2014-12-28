package com.pixelBender.facade
{
	public class LogicXML
	{
		private var xml:XML;
		public function LogicXML()
		{
			xml = <logic>
                    <reflections>
                        <reflection type="gameComponent" 	name="_game__componentProxy"					className="com.pixelBender.model.GameComponentProxy" />
                        <reflection type="gameComponent" 	name="_game__assetProxy" 						className="com.pixelBender.model.AssetProxy" />
						<reflection type="gameComponent" 	name="_game__fileReferenceProxy"				className="com.pixelBender.model.FileReferenceProxy" />
                        <reflection type="gameComponent" 	name="_game__soundProxy" 						className="com.pixelBender.model.SoundProxy" />
                        <reflection type="gameComponent" 	name="_game__localizationProxy"					className="com.pixelBender.model.LocalizationProxy" />
                        <reflection type="gameComponent" 	name="_game__tweenProxy"						className="com.pixelBender.model.TweenProxy" />
                        <reflection type="gameComponent" 	name="_game__gameScreenManagerMediator"			className="com.pixelBender.view.gameScreen.GameScreenManagerMediator" />
                        <reflection type="gameComponent" 	name="_game__popupManagerMediator"				className="com.pixelBender.view.popup.PopupManagerMediator" />
                        <reflection type="asset" 			name="swf" 										className="com.pixelBender.model.vo.asset.SWFAssetVO" />
                        <reflection type="asset"			name="xml" 										className="com.pixelBender.model.vo.asset.XMLAssetVO" />
                        <reflection type="asset"			name="sound" 									className="com.pixelBender.model.vo.asset.SoundAssetVO" />
                        <reflection type="assetLoader"		name="swf" 										className="com.pixelBender.model.component.loader.SWFLoader" />
                        <reflection type="assetLoader"		name="xml" 										className="com.pixelBender.model.component.loader.XMLLoader" />
                        <reflection type="assetLoader"		name="sound" 									className="com.pixelBender.model.component.loader.SoundLoader" />
                    </reflections>
                    <components>
                        <component name="_game__componentProxy" 					type="proxy" />
                        <component name="_game__assetProxy" 						type="proxy" />
						<component name="_game__tweenProxy" 						type="proxy" />
                        <component name="_game__soundProxy" 						type="proxy" />
                        <component name="_game__localizationProxy" 					type="proxy" />
                        <component name="_game__fileReferenceProxy" 				type="proxy" />
                        <component name="_game__gameScreenManagerMediator" 			type="mediator" />
                        <component name="_game__popupManagerMediator" 				type="mediator" />
                    </components>
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