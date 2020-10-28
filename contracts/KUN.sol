pragma solidity 0.6.2;

import "./lib/ERC20Capped.sol";
import "./lib/MinterControl.sol";
import "./lib/VersionedInitializable.sol";

contract KUN is ERC20Capped, MinterControl, VersionedInitializable {
    using SafeMath for uint256;

    uint256 public constant maxSupply = 12000000000000000000000000;

    function getRevision() internal override pure returns (uint256) {
        return uint256(0x1);
    }

    function initialize(address admin) public initializer {
        initializeMinterControl(admin);
        initializeERC20Capped("QIAN governance token", "KUN", 18, maxSupply);
    }

    function mint(address account, uint256 amount) public onlyMinter {
        _mint(account, amount);
        _approveMint(
            _msgSender(),
            mintAllowances[_msgSender()].sub(
                amount,
                "Mint amount exceeds allowance"
            )
        );
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) public {
        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
            amount,
            "ERC20: burn amount exceeds allowance"
        );
        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
    }
}
