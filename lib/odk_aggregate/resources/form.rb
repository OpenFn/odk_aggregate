require 'odk_aggregate/http/response_processors/form_response'
require 'multi_xml'
require 'ox'

module OdkAggregate
  module Form

    def all_forms
      result = []
      xforms = MultiXml.parse(@connection.send(:get, 'xformsList').body)["xforms"]

      if xforms["xform"]
        if xforms["xform"].is_a?(Array)
          xforms["xform"].each do |f|
            result << OdkAggregate::FormResponse.new(f, @connection, @username, @password)
          end
        else
          result << OdkAggregate::FormResponse.new(xforms["xform"], @connection, @username, @password)
        end
      end
      result
    end

    def first_form
      OdkAggregate::FormResponse.new MultiXml.parse(@connection.send(:get, 'xformsList').body)["xforms"]["xform"].first,
                                     @connection, @username, @password
    end

    # def last_form
    #   response = MultiXml.parse(@connection.send(:get, 'xformsList', formID: id, verbose: true).body)["xforms"]["xform"]
    #   OdkAggregate::FormResponse.new reponse.last, @connection, @username, @password
    # end

    def find_form(id)
      response = MultiXml.parse(@connection.send(:get, 'xformsList', formID: id, verbose: true).body)["xforms"]["xform"]
      OdkAggregate::FormResponse.new response, @connection, @username, @password
    end

  end
end
