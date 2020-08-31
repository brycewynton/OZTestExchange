pragma solidity ^0.6.2;

// import base initializable contract
import "@openzeppelin/upgrades/contracts/Initializable.sol";

// import the IERC20 interface and the SafeMath library
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";

contract TokenExchange is Initializable {
	using SafeMath for uint256;

	// contract state: exchange rate and token
	uint256 public rate;
	IERC20 public token;
	address public owner;	

	// Initializer function (this replaces the constructor that would usially be here)
	function initialize(uint256 _rate, IERC20 _token) public initializer {
		rate = _rate;
		token = _token;
	}

	// Send tokens back to the sender using predefined exchange rate
	receive() external payable {
		uint256 tokens = msg.value.mul(rate);
		token.transfer(msg.sender, tokens);
	}
	
	function withdraw() public {
		require(
			msg.sender == owner,
			"Address not allowed to call this function"
		);
		msg.sender.transfer(address(this).balance);
	}

	// To be run during upgrades, ensures it cannot be called again
	function setOwner(address _owner) public {
		require(owner == address(0), "Owner already set, cannnot modify!");
		owner = _owner;
	}
}

