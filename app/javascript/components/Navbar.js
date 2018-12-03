import { NavLink } from "react-router-dom";
import React from "react";

const Navbar = () => (
  <ul className="list-reset flex mt-10 mx-20">
    <li className="mr-6 p5">
      <NavLink
        activeClassName="text-teal-darker"
        className="hover:text-teal-light no-underline"
        to="/"
      >
        Hello
      </NavLink>
    </li>
    <li className="mr-6 p5">
      <NavLink
        activeClassName="text-teal-darker"
        className="hover:text-teal-light no-underline"
        to="/statistics"
      >
        Statistics
      </NavLink>
    </li>
    <li className="mr-6 p5">
      <NavLink
        activeClassName="text-teal-darkest"
        className="hover:text-teal-light no-underline"
        to={`goodbye`}
      >
        Goodbye
      </NavLink>
    </li>
    <li className="mr-6 p5">
      <a href="/auth/google_oauth2">Login</a>
    </li>
  </ul>
);
export default Navbar;
