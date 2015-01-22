require 'uri'

module OdkAggregate
  class FormResponse

    def initialize(response, connection, username, password)
      @response = response
      @connection = connection
      @username = username
      @password = password
      @download_url = download_url
    end

    def full_response
      @response
    end

    def download_url
      url = URI(@response["downloadUrl"])
      url.path.to_s + "?" +  url.query.to_s
    end

    def manifest_url
      @response["manifestUrl"]
    end

    def form_id
      @response["formID"]
    end

    def fields
      resp = @connection.send(:get, @download_url).body
      response = MultiXml.parse resp, typecast_xml_value: false      
      final_response = response["html"]["head"]["model"]["bind"]

      response["html"]["body"].each_pair do |key, value| 
        if value.is_a?(Array)      
          value.each do |v|
            set_field_response_group(final_response, key, v)
          end
        else
          set_field_response_group(final_response, key, value)
        end
      end

      final_response

    end

    def get_top_element
      resp = @connection.send(:get, @download_url).body
      response = MultiXml.parse resp, typecast_xml_value: false
      response["html"]["head"]["model"]["bind"].first["nodeset"].split("/")[1]
    end

    protected

    def set_field_response_group(final_response, key, value)
      ref = value["ref"]      
      final_response.each do |field|
        if field["nodeset"].include?("#{ref}")
          if key.eql?("group")
            field["group"] = true
          else
            field["group"] = false
          end
        end
      end
    end
  end
end
