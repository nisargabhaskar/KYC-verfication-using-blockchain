pragma solidity ^0.5.9;

contract kyc {

  
    address admin;
    
    
    struct Customer {
        string userName;   
        string data_hash;  
        uint8 upvotes;
        address bank;
    }

    
    struct Bank {
        address ethAddress;     
        string bankName;
        string regNumber;          
    }

    
    struct KYCRequest {
        string userName;     
        string data_hash;  
        address bank;
    }

    
    mapping(string => Customer) customers;
    string[] customerNames;

    
    mapping(address => Bank) banks;
    address[] bankAddresses;

    
    mapping(string => KYCRequest) kycRequests;
    string[] customerDataList;

    
    mapping(string => mapping(address => uint256)) upvotes;

    
    constructor() public {
        admin = msg.sender;
    }

   
    function addKycRequest(string memory _userName, string memory _customerData) public returns (uint8) {
       
        require(kycRequests[_customerData].bank == address(0), "This user already has a KYC request with same data in process.");
        
        kycRequests[_customerData].data_hash = _customerData;
        kycRequests[_customerData].userName = _userName;
        kycRequests[_customerData].bank = msg.sender;
        customerDataList.push(_customerData);
        return 1;
    }

    
    function addCustomer(string memory _userName, string memory _customerData) public returns (uint8) {
        require(customers[_userName].bank == address(0), "This customer is already present, please call modifyCustomer to edit the customer data");
        customers[_userName].userName = _userName;
        customers[_userName].data_hash = _customerData;
        customers[_userName].bank = msg.sender;
        customers[_userName].upvotes = 0;
        customerNames.push(_userName);
        return 1;
    }

   
    function removeKYCRequest(string memory _userName) public returns (uint8) {
        uint8 i=0;
        for (uint256 i = 0; i< customerDataList.length; i++) {
            if (stringsEquals(kycRequests[customerDataList[i]].userName,_userName)) {
                delete kycRequests[customerDataList[i]];
                for(uint j = i+1;j < customerDataList.length;j++) 
                { 
                    customerDataList[j-1] = customerDataList[j];
                }
                customerDataList.length --;
                i=1;
            }
        }
        return i; 
    }

    
    function removeCustomer(string memory _userName) public returns (uint8) {
            for(uint i = 0;i < customerNames.length;i++) 
            { 
                if(stringsEquals(customerNames[i],_userName))
                {
                    delete customers[_userName];
                    for(uint j = i+1;j < customerNames.length;j++) 
                    {
                        customerNames[j-1] = customerNames[j];
                    }
                    customerNames.length--;
                    return 1;
                }
                
            }
            return 0;
    }

    
    function modifyCustomer(string memory _userName, string memory _newcustomerData) public returns (uint8) {
        for(uint i = 0;i < customerNames.length;i++) 
            { 
                if(stringsEquals(customerNames[i],_userName))
                {
                    customers[_userName].data_hash = _newcustomerData;
                    return 1;
                }
            
            }
            return 0;
    }

    
    function viewCustomer(string memory _userName) public view returns (string memory, string memory, uint8, address) {
        return (customers[_userName].userName, customers[_userName].data_hash, customers[_userName].upvotes, customers[_userName].bank);
    }

    
    function Upvote(string memory _userName) public returns (uint8) {
        for(uint i = 0;i < customerNames.length;i++) 
            { 
                if(stringsEquals(customerNames[i],_userName))
                {
                    customers[_userName].upvotes++;
                    upvotes[_userName][msg.sender] = now;
                    return 1;
                }
            
            }
            return 0;
        
    }


    function stringsEquals(string storage _a, string memory _b) internal view returns (bool) {
        bytes storage a = bytes(_a);
        bytes memory b = bytes(_b); 
        if (a.length != b.length)
            return false;
        // @todo unroll this loop
        for (uint i = 0; i < a.length; i ++)
        {
            if (a[i] != b[i])
                return false;
        }
        return true;
    }

}