module Newebpay
    class Mpg
      attr_accessor :info
  
      def initialize(params)
        @key = "l2Nvw3YlqoEk6G4HqRKDAYpHKZWxN4LM"
        @iv = "gXYC1Fpliev4dtLw"
        @merchant_id = "MS33690061"
        @info = {}  
        set_info(params)
      end
  
      def form_info
        {
          MerchantID: @merchant_id,
          TradeInfo: trade_info,
          TradeSha: trade_sha,
          Version: "1.6",
        }
      end
  
      private
  
      def trade_info
        aes_encode(url_encoded_query_string)
      end
  
      def trade_sha
        sha256_encode(@key, @iv, trade_info)
      end
  
      def set_info(order)  
        info[:MerchantID] = @merchant_id
        info[:MerchantOrderNo] = order.serial
        info[:Amt] = order.amount.to_i 
        info[:ItemDesc] = order.wish_list_id 
        info[:TimeStamp] = Time.now.to_i 
        info[:RespondType] = "JSON"
        info[:Version] = "1.6"
        info[:ReturnURL] = "https://87b9-61-220-182-115.jp.ngrok.io/orders/#{order.serial}/pay"
      end
  
      def url_encoded_query_string
        URI.encode_www_form(info)
      end
  
      def aes_encode(string)
        cipher = OpenSSL::Cipher::AES256.new(:CBC)
        cipher.encrypt
        cipher.key = @key
        cipher.iv = @iv
        cipher.padding = 0
        padding_data = add_padding(string)
        encrypted = cipher.update(padding_data) + cipher.final
        encrypted.unpack('H*').first
      end
  
      def add_padding(data, block_size = 32)
        pad = block_size - (data.length % block_size)
        data + (pad.chr * pad)
      end
  
      def sha256_encode(key, iv, trade_info)
        encode_string = "HashKey=#{key}&#{trade_info}&HashIV=#{iv}"
        Digest::SHA256.hexdigest(encode_string).upcase
      end

    end
  end
