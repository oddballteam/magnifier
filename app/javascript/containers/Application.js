import React, { Component } from 'react'
import ApolloClient from "apollo-boost";
import Hello from '../components/Hello'
import Article from '../components/Article'
import { ApolloProvider } from "react-apollo";


const client = new ApolloClient({
  uri: "/graphql"
});


export default class ApplicationContainer extends Component {
	render() {
		return (
			<ApolloProvider client={client} >
			<div className="container mx-auto">
				<Hello name="world" />
				<Article>
				</Article>
			</div>
			</ApolloProvider>
		);
	}
}