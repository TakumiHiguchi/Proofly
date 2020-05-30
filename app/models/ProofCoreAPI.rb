class ProofCoreAPI
    require "json"
    
    ETHEREUM_TOKEN_PATH = "#{Dir.pwd}/contracts/Proofcore.sol"
    
    GANACHE_URL = 'HTTP://127.0.0.1:7545' #development
    
    CONTRACT_ADDRESS = "0x684b3cae04049b1b20297b2f0f863d2f19cd6590"
        
        

    def set_client( _address, _password)
        @client = Ethereum::HttpClient.new(GANACHE_URL)
        #おそらくGanacheだからアドレス指定なしで使える。GethはIPC使うっぽい？https://github.com/shiki-tak/token-trader-app/blob/master/app/models/ethereumAPI.rb
        @client.personal_unlock_account( _address, _password, 30)
    end
    
    def createWorkToken(ether_address, ether_address_password, workHash, type, author, agree)
        set_client(ether_address, ether_address_password)
        
        @contract = Ethereum::Contract.create(file: ETHEREUM_TOKEN_PATH,address: CONTRACT_ADDRESS, client: @client)
        
        begin
            @timestamp = @contract.transact_and_wait.create_new_work(workHash, author, type, agree)
            return true, @timestamp, nil
        rescue => e
            puts e.message
            return false, nil, e.message
        end
    end
    
    def getWorkToken(ether_address, ether_address_password, workHash)
        set_client(ether_address, ether_address_password)
        
        @contract = Ethereum::Contract.create(file: ETHEREUM_TOKEN_PATH,address: CONTRACT_ADDRESS, client: @client)
        begin
            @proofWorkDatas = @contract.call.show_work_details(workHash)
            return true, @proofWorkDatas, nil
        rescue => e
            puts e.message
            return false, nil, e.message
        end
    end
end
