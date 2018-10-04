import React, { Component } from 'react'
import Hello from '../components/Hello'
import Article from '../components/Article'


export default class ApplicationContainer extends Component {
	render() {
		return (
			<div className="container mx-auto">
				<Hello name="world" />
				<Article>
					<p className="my-4">
						Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac nunc eu est convallis mattis nec at augue. Vestibulum vitae tortor nunc. Duis nisl urna, rhoncus sit amet lobortis vel, feugiat id nibh. In sed vestibulum lorem, a ornare eros. Proin elementum augue ac magna hendrerit maximus. Morbi mauris purus, commodo aliquam odio ac, porta ornare risus. Morbi est nunc, sollicitudin vitae faucibus vel, porttitor et arcu. Donec euismod viverra risus a lacinia. Nulla vitae venenatis mi. Praesent id enim mollis, aliquam ante vehicula, mattis justo. Nullam auctor justo ex, quis pretium nunc vehicula nec. Suspendisse arcu tortor, interdum eget varius ac, lacinia eget lacus.
					</p>
					<p className="my-4">
						Donec imperdiet, ex eu tincidunt accumsan, nisi eros congue metus, et pharetra tellus est sit amet lectus. Aenean gravida ultricies arcu eget faucibus. Suspendisse dignissim eros non fringilla facilisis. Aliquam scelerisque interdum leo, sit amet sollicitudin nisi auctor vitae. Maecenas eleifend imperdiet libero, in volutpat massa scelerisque nec. Donec dignissim dolor odio. Cras diam lorem, hendrerit et felis in, sagittis ultricies elit. Cras pulvinar consequat lectus, ut pulvinar ex ultrices vel. Etiam rhoncus eleifend erat, at scelerisque velit iaculis ut.
					</p>

					<p className="my-4">
						Nulla posuere elementum urna, et bibendum arcu euismod pulvinar. Nullam quis massa neque. Nulla egestas eget leo vel gravida. Morbi suscipit cursus sagittis. Fusce vel urna at mi porttitor commodo. Etiam maximus erat vitae congue ullamcorper. Donec et rutrum odio, imperdiet pellentesque felis. Ut tempor efficitur iaculis. Curabitur lacinia metus nec diam convallis, lacinia porttitor neque dapibus. Quisque lacinia porta justo at pretium. Vestibulum vitae ante odio. Etiam accumsan, mauris et tincidunt condimentum, dolor erat cursus neque, eget cursus lectus metus ac augue. Praesent non consequat augue. Nullam cursus tincidunt eros. Nullam ut ullamcorper libero. Pellentesque lacinia tortor non sapien porta posuere.
					</p>

					<p className="my-4">
						Cras ac sollicitudin justo. Proin sit amet molestie purus, ac interdum dui. Nunc vulputate nibh eget faucibus ultrices. Nam vitae odio pulvinar, finibus tellus eu, porta lectus. Nullam tempor est nunc, et finibus ligula elementum vel. Integer commodo, diam ac ultricies tincidunt, urna nulla cursus odio, at interdum ipsum nunc vitae nulla. Sed orci ipsum, mollis accumsan velit nec, consectetur auctor massa. Etiam nec magna placerat, elementum enim nec, bibendum eros. Nullam ac arcu diam. Donec laoreet erat eget ligula lacinia interdum.
					</p>

					<p className="my-4">
						Pellentesque sed vulputate turpis, ac fermentum velit. Phasellus rutrum justo et quam accumsan vulputate. Donec elit arcu, egestas non augue nec, ornare mollis felis. Nunc ac velit id mi luctus commodo. Vivamus tellus velit, convallis eu elementum at, posuere et mi. Ut pretium ac diam nec porta. Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque maximus erat tincidunt, viverra ex eget, iaculis dui. Nunc a sem ut mi viverra lobortis. Sed egestas vitae orci nec sodales. Nunc lectus nisl, tempus vel commodo ac, rhoncus in est. Aliquam erat volutpat. Morbi imperdiet euismod quam quis laoreet. Curabitur scelerisque mi euismod sapien vestibulum, eu consectetur orci pulvinar. Suspendisse gravida eleifend ante, eget pharetra magna venenatis non.
					</p>
				</Article>
			</div>
			
		);
	}
}