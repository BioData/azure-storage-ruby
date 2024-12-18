# frozen_string_literal: true

#-------------------------------------------------------------------------
# # Copyright (c) Microsoft and contributors. All rights reserved.
#
# The MIT License(MIT)

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files(the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions :

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#--------------------------------------------------------------------------
module Azure::Storage
  include Azure::Storage::Common::Service
  StorageService = Azure::Storage::Common::Service::StorageService

  module Queue
    class QueueService < StorageService
      class << self
        # Public: Creates an instance of [Azure::Storage::Queue::QueueService]
        #
        # ==== Attributes
        #
        # * +options+    - Hash. Optional parameters.
        #
        # ==== Options
        #
        # Accepted key/value pairs in options parameter are:
        #
        # * +:use_development_storage+        - TrueClass|FalseClass. Whether to use storage emulator.
        # * +:development_storage_proxy_uri+  - String. Used with +:use_development_storage+ if emulator is hosted other than localhost.
        # * +:storage_account_name+           - String. The name of the storage account.
        # * +:storage_access_key+             - Base64 String. The access key of the storage account.
        # * +:storage_sas_token+              - String. The signed access signature for the storage account or one of its service.
        # * +:storage_queue_host+             - String. Specified Queue service endpoint or hostname
        # * +:storage_dns_suffix+             - String. The suffix of a regional Storage Service, to
        # * +:default_endpoints_protocol+     - String. http or https
        # * +:use_path_style_uri+             - String. Whether use path style URI for specified endpoints
        # * +:ca_file+                        - String. File path of the CA file if having issue with SSL
        # * +:ssl_version+                    - Symbol. The ssl version to be used, sample: :TLSv1_1, :TLSv1_2, for the details, see https://github.com/ruby/openssl/blob/master/lib/openssl/ssl.rb
        # * +:ssl_min_version+                - Symbol. The min ssl version supported, only supported in Ruby 2.5+
        # * +:ssl_max_version+                - Symbol. The max ssl version supported, only supported in Ruby 2.5+
        # * +:user_agent_prefix+              - String. The user agent prefix that can identify the application calls the library
        #
        # The valid set of options include:
        # * Storage Emulator: +:use_development_storage+ required, +:development_storage_proxy_uri+ optionally
        # * Storage account name and key: +:storage_account_name+ and +:storage_access_key+ required, set +:storage_dns_suffix+ necessarily
        # * Storage account name and SAS token: +:storage_account_name+ and +:storage_sas_token+ required, set +:storage_dns_suffix+ necessarily
        # * Specified hosts and SAS token: At least one of the service host and SAS token. It's up to user to ensure the SAS token is suitable for the serivce
        # * Anonymous Queue: only +:storage_queue_host+, if it is to only access queues within a container
        #
        # Additional notes:
        # * Specified hosts can be set when use account name with access key or sas token
        # * +:default_endpoints_protocol+ can be set if the scheme is not specified in hosts
        # * Storage emulator always use path style URI
        # * +:ca_file+ is independent.
        #
        # When empty options are given, it will try to read settings from Environment Variables. Refer to [Azure::Storage::Common::ClientOptions.env_vars_mapping] for the mapping relationship
        #
        # @return [Azure::Storage::Queue::QueueService]
        def create(options = {}, &block)
          service_options = { client: Azure::Storage::Common::Client::create(options, &block), api_version: Azure::Storage::Queue::Default::STG_VERSION }
          service_options[:user_agent_prefix] = options[:user_agent_prefix] if options[:user_agent_prefix]
          Azure::Storage::Queue::QueueService.new(service_options, &block)
        end

        # Public: Creates an instance of [Azure::Storage::Queue::QueueService] with Storage Emulator
        #
        # ==== Attributes
        #
        # * +proxy_uri+    - String. Used with +:use_development_storage+ if emulator is hosted other than localhost.
        #
        # @return [Azure::Storage::Queue::QueueService]
        def create_development(proxy_uri = nil, &block)
          service_options = { client: Azure::Storage::Common::Client::create_development(proxy_uri, &block), api_version: Azure::Storage::Queue::Default::STG_VERSION }
          Azure::Storage::Queue::QueueService.new(service_options, &block)
        end

        # Public: Creates an instance of [Azure::Storage::Queue::QueueService] from Environment Variables
        #
        # @return [Azure::Storage::Queue::QueueService]
        def create_from_env(&block)
          service_options = { client: Azure::Storage::Common::Client::create_from_env(&block), api_version: Azure::Storage::Queue::Default::STG_VERSION }
          Azure::Storage::Queue::QueueService.new(service_options, &block)
        end

        # Public: Creates an instance of [Azure::Storage::Queue::QueueService] from Environment Variables
        #
        # ==== Attributes
        #
        # * +connection_string+    - String. Please refer to https://azure.microsoft.com/en-us/documentation/articles/storage-configure-connection-string/.
        #
        # @return [Azure::Storage::Queue::QueueService]
        def create_from_connection_string(connection_string, &block)
          service_options = { client: Azure::Storage::Common::Client::create_from_connection_string(connection_string, &block), api_version: Azure::Storage::Queue::Default::STG_VERSION }
          Azure::Storage::Queue::QueueService.new(service_options, &block)
        end
      end

      # Public: Initializes an instance of [Azure::Storage::Queue::QueueService]
      #
      # ==== Attributes
      #
      # * +options+    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      #
      # * +:use_development_storage+        - TrueClass|FalseClass. Whether to use storage emulator.
      # * +:development_storage_proxy_uri+  - String. Used with +:use_development_storage+ if emulator is hosted other than localhost.
      # * +:storage_connection_string+      - String. The storage connection string.
      # * +:storage_account_name+           - String. The name of the storage account.
      # * +:storage_access_key+             - Base64 String. The access key of the storage account.
      # * +:storage_sas_token+              - String. The signed access signature for the storage account or one of its service.
      # * +:storage_queue_host+              - String. Specified Queue serivce endpoint or hostname
      # * +:storage_dns_suffix+             - String. The suffix of a regional Storage Serivce, to
      # * +:default_endpoints_protocol+     - String. http or https
      # * +:use_path_style_uri+             - String. Whether use path style URI for specified endpoints
      # * +:ca_file+                        - String. File path of the CA file if having issue with SSL
      # * +:ssl_version+                    - Symbol. The ssl version to be used, sample: :TLSv1_1, :TLSv1_2, for the details, see https://github.com/ruby/openssl/blob/master/lib/openssl/ssl.rb
      # * +:ssl_min_version+                - Symbol. The min ssl version supported, only supported in Ruby 2.5+
      # * +:ssl_max_version+                - Symbol. The max ssl version supported, only supported in Ruby 2.5+
      # * +:user_agent_prefix+              - String. The user agent prefix that can identify the application calls the library
      # * +:client+                         - Azure::Storage::Common::Client. The common client used to initalize the service.
      #
      # The valid set of options include:
      # * Storage Emulator: +:use_development_storage+ required, +:development_storage_proxy_uri+ optionally
      # * Storage account name and key: +:storage_account_name+ and +:storage_access_key+ required, set +:storage_dns_suffix+ necessarily
      # * Storage account name and SAS token: +:storage_account_name+ and +:storage_sas_token+ required, set +:storage_dns_suffix+ necessarily
      # * Specified hosts and SAS token: At least one of the service host and SAS token. It's up to user to ensure the SAS token is suitable for the serivce
      # * Azure::Storage::Common::Client: The common client used to initalize the service. This client can be initalized and used repeatedly.
      # * Anonymous Queue: only +:storage_queue_host+, if it is to only access queues within a container
      #
      # Additional notes:
      # * Specified hosts can be set when use account name with access key or sas token
      # * +:default_endpoints_protocol+ can be set if the scheme is not specified in hosts
      # * Storage emulator always use path style URI
      # * +:ca_file+ is independent.
      #
      # When empty options are given, it will try to read settings from Environment Variables. Refer to [Azure::Storage::Common::ClientOptions.env_vars_mapping] for the mapping relationship
      def initialize(options = {}, &block)
        service_options = options.clone
        client_config = service_options[:client] ||= Azure::Storage::Common::Client::create(service_options, &block)
        @user_agent_prefix = service_options[:user_agent_prefix] if service_options[:user_agent_prefix]
        @api_version = service_options[:api_version] || Azure::Storage::Queue::Default::STG_VERSION
        signer = service_options[:signer] || client_config.signer || Azure::Storage::Common::Core::Auth::SharedKey.new(client_config.storage_account_name, client_config.storage_access_key)
        signer.api_ver = @api_version if signer.is_a? Azure::Storage::Common::Core::Auth::SharedAccessSignatureSigner
        super(signer, client_config.storage_account_name, service_options, &block)
        @storage_service_host[:primary] = client.storage_queue_host
        @storage_service_host[:secondary] = client.storage_queue_host true
      end

      # Public: Get a list of Queues from the server
      #
      # ==== Attributes
      #
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:prefix+                    - String. Filters the results to return only containers
      #                                  whose name begins with the specified prefix. (optional)
      # * +:marker+                    - String. An identifier the specifies the portion of the
      #                                  list to be returned. This value comes from the property
      #                                  Azure::Service::EnumerationResults.continuation_token when there
      #                                  are more containers available than were returned. The
      #                                  marker value may then be used here to request the next set
      #                                  of list items. (optional)
      # * +:max_results+               - Integer. Specifies the maximum number of containers to return.
      #                                  If max_results is not specified, or is a value greater than
      #                                  5,000, the server will return up to 5,000 items. If it is set
      #                                  to a value less than or equal to zero, the server will return
      #                                  status code 400 (Bad Request). (optional)
      # * +:metadata+                  - Boolean. Specifies whether or not to return the container metadata.
      #                                  (optional, Default=false)
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      # * +:location_mode+             - LocationMode. Specifies the location mode used to decide
      #                                  which location the request should be sent to.
      #
      # NOTE: Metadata requested with the :metadata parameter must have been stored in
      # accordance with the naming restrictions imposed by the 2009-09-19 version of the queue
      # service. Beginning with that version, all metadata names must adhere to the naming
      # conventions for C# identifiers.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179466
      #
      # Any metadata with invalid names which were previously stored, will be returned with the
      # key "x-ms-invalid-name" in the metadata hash. This may contain multiple values and be an
      # Array (vs a String if it only contains a single value).
      #
      # Returns an Azure::Storage::Common::EnumerationResults
      def list_queues(options = {})
        query = {}
        query["prefix"] = options[:prefix] if options[:prefix]
        query["marker"] = options[:marker] if options[:marker]
        query["maxresults"] = options[:max_results].to_s if options[:max_results]
        query["include"] = "metadata" if options[:metadata] == true
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        options[:request_location_mode] = Azure::Storage::Common::RequestLocationMode::PRIMARY_OR_SECONDARY
        uri = collection_uri(query, options)
        response = call(:get, uri, nil, {}, options)

        Serialization.queue_enumeration_results_from_xml(response.body)
      end

      # Public: Clears all messages from the queue.
      #
      # If a queue contains a large number of messages, Clear Messages may time out
      # before all messages have been deleted. In this case the Queue service will
      # return status code 500 (Internal Server Error), with the additional error
      # code OperationTimedOut. If the operation times out, the client should
      # continue to retry Clear Messages until it succeeds, to ensure that all
      # messages have been deleted.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The name of the queue.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179454
      #
      # Returns nil on success
      def clear_messages(queue_name, options = {})
        query = {}
        query["timeout"] = options[:timeout].to_s if options[:timeout]
        uri = messages_uri(queue_name, query)
        call(:delete, uri, nil, {}, options)
        nil
      end

      # Public: Creates a new queue under the storage account.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:metadata+                  - Hash. A hash of user defined metadata.
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179342
      #
      # Returns nil on success
      def create_queue(queue_name, options = {})
        query = {}
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        uri = queue_uri(queue_name, query)

        headers = {}
        StorageService.add_metadata_to_headers(options[:metadata] || {}, headers) if options[:metadata]

        call(:put, uri, nil, headers, options)
        nil
      end

      # Public: Deletes a queue.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179436
      #
      # Returns nil on success
      def delete_queue(queue_name, options = {})
        query = {}
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        uri = queue_uri(queue_name, query)

        call(:delete, uri, nil, {}, options)
        nil
      end

      # Public: Returns queue properties, including user-defined metadata.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      # * +:location_mode+             - LocationMode. Specifies the location mode used to decide
      #                                  which location the request should be sent to.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179384
      #
      # Returns a tuple of (approximate_message_count, metadata)
      # * approximate_messages_count  - Integer. The approximate number of messages in the queue. This number is not
      #   lower than the actual number of messages in the queue, but could be higher.
      # * metadata                    - Hash. The queue metadata (Default: {})
      #
      def get_queue_metadata(queue_name, options = {})
        query = { "comp" => "metadata" }
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        options[:request_location_mode] = Azure::Storage::Common::RequestLocationMode::PRIMARY_OR_SECONDARY
        uri = queue_uri(queue_name, query, options)

        response = call(:get, uri, nil, {}, options)

        approximate_messages_count = response.headers["x-ms-approximate-messages-count"]
        metadata = Serialization.metadata_from_headers(response.headers)

        return approximate_messages_count.to_i, metadata
      end

      # Public: Sets user-defined metadata on the queue. To delete queue metadata, call
      # this API with an empty hash in the metadata parameter.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +metadata+                   - Hash. A hash of user defined metadata
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179348
      #
      # Returns nil on success
      def set_queue_metadata(queue_name, metadata, options = {})
        query = { "comp" => "metadata" }
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        uri = queue_uri(queue_name, query)

        headers = {}
        StorageService.add_metadata_to_headers(metadata || {}, headers)

        call(:put, uri, nil, headers, options)
        nil
      end

      # Public: Gets the access control list (ACL) for the queue.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      # * +:location_mode+             - LocationMode. Specifies the location mode used to decide
      #                                  which location the request should be sent to.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/jj159101
      #
      # Returns a list of Azure::Storage::Entity::SignedIdentifier instances
      def get_queue_acl(queue_name, options = {})
        query = { "comp" => "acl" }
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        options[:request_location_mode] = Azure::Storage::Common::RequestLocationMode::PRIMARY_OR_SECONDARY
        response = call(:get, queue_uri(queue_name, query, options), nil, {}, options)

        signed_identifiers = []
        signed_identifiers = Serialization.signed_identifiers_from_xml(response.body) unless response.body == (nil) || response.body.length < (1)
        signed_identifiers
      end

      # Public: Sets the access control list (ACL) for the queue.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:signed_identifiers+        - Array. A list of Azure::Storage::Entity::SignedIdentifier instances
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/jj159099
      #
      # Returns nil on success
      def set_queue_acl(queue_name, options = {})
        query = { "comp" => "acl" }
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        uri = queue_uri(queue_name, query)
        body = nil
        body = Serialization.signed_identifiers_to_xml(options[:signed_identifiers]) if options[:signed_identifiers] && options[:signed_identifiers].length > 0

        call(:put, uri, body, {}, options)
        nil
      end

      # Public: Adds a message to the queue and optionally sets a visibility timeout for the message.
      #
      # ==== Attributes
      #
      # * +queue_name+   - String. The queue name.
      # * +message_text+ - String. The message contents. Note that the message content must be in a format that may be encoded with UTF-8.
      # * +options+      - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:visibility_timeout+        - Integer. Specifies the new visibility timeout value, in seconds, relative to server
      #                                  time. The new value must be larger than or equal to 0, and cannot be larger than 7
      #                                  days. The visibility timeout of a message cannot be set to a value later than the
      #                                  expiry time. :visibility_timeout should be set to a value smaller than the
      #                                  time-to-live value. If not specified, the default value is 0.
      # * +:message_ttl+               - Integer. Specifies the time-to-live interval for the message, in seconds. The maximum
      #                                  time-to-live allowed is 7 days. If not specified, the default time-to-live is 7 days.
      # * +:encode+                    - Boolean. If set to true, the message will be base64 encoded.
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179346
      #
      # Returns a list of Azure::Storage::Queue::Message object containing only the echo of request on success
      def create_message(queue_name, message_text, options = {})
        query = {}

        unless options.empty?
          query["visibilitytimeout"] = options[:visibility_timeout] if options[:visibility_timeout]
          query["messagettl"] = options[:message_ttl] if options[:message_ttl]
          query["timeout"] = options[:timeout].to_s if options[:timeout]
        end

        uri = messages_uri(queue_name, query)
        body = Serialization.message_to_xml(message_text, options[:encode])

        response = call(:post, uri, body, {}, options)
        Serialization.queue_messages_from_xml(response.body, options[:decode])
      end

      # Public: Deletes a specified message from the queue.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +message_id+                 - String. The id of the message.
      # * +pop_receipt+                - String. The valid pop receipt value returned from an earlier call to the Get Messages or
      #                                  Update Message operation.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179347
      #
      # Returns nil on success
      #
      # Remarks:
      #
      # When a message is successfully deleted, it is immediately marked for deletion and is no longer accessible to
      # clients. The message is later removed from the queue during garbage collection.
      #
      # After a client retrieves a message with the Get Messages operation, the client is expected to process and
      # delete the message. To delete the message, you must have two items of data returned in the response body of
      # the Get Messages operation:
      #
      # * The message ID, an opaque GUID value that identifies the message in the queue.
      #
      # * A valid pop receipt, an opaque value that indicates that the message has been retrieved.
      #
      # The message ID is returned from the previous Get Messages operation. The pop receipt is returned from the most
      # recent Get Messages or Update Message operation. In order for the Delete Message operation to succeed, the pop
      # receipt specified on the request must match the pop receipt returned from the Get Messages or Update Message
      # operation.
      #
      # Pop receipts remain valid until one of the following events occurs:
      #
      # * The message has expired.
      #
      # * The message has been deleted using the last pop receipt received either from Get Messages or Update Message.
      #
      # * The invisibility time has elapsed and the message has been dequeued by a Get Messages request. When the
      # invisibility time elapses, the message becomes visible again. If it is retrieved by another Get Messages
      # request, the returned pop receipt can be used to delete or update the message.
      #
      # * The message has been updated with a new visibility timeout. When the message is updated, a new pop receipt
      # will be returned.
      #
      # If the message has already been deleted when Delete Message is called, the Queue service returns status code
      # 404 (Not Found).
      #
      # If a message with a matching pop receipt is not found, the service returns status code 400 (Bad Request), with
      # additional error information indicating that the cause of the failure was a mismatched pop receipt.
      #
      def delete_message(queue_name, message_id, pop_receipt, options = {})
        query = { "popreceipt" => pop_receipt }
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        uri = message_uri(queue_name, message_id, query)

        call(:delete, uri, nil, {}, options)
        nil
      end

      # Public: Retrieves one or more messages from the front of the queue, without changing the message visibility.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:number_of_messages+        - Integer. How many messages to return. (optional, Default: 1)
      # * +:decode+                    - Boolean. Boolean value indicating if the message should be base64 decoded.
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      # * +:location_mode+             - LocationMode. Specifies the location mode used to decide
      #                                  which location the request should be sent to.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179472
      #
      # Returns a list of Azure::Storage::Entity::Queue::Message instances
      def peek_messages(queue_name, options = {})
        number_of_messages = 1
        number_of_messages = options[:number_of_messages] if options[:number_of_messages]

        query = { "peekonly" => "true", "numofmessages" => number_of_messages.to_s }
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        options[:request_location_mode] = Azure::Storage::Common::RequestLocationMode::PRIMARY_OR_SECONDARY
        uri = messages_uri(queue_name, query, options)
        response = call(:get, uri, nil, {}, options)

        messages = Serialization.queue_messages_from_xml(response.body, options[:decode])
        messages
      end

      # Public: Retrieves one or more messages from the front of the queue.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +visibility_timeout+         - Integer. The new visibility timeout value, in seconds, relative to server time.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:number_of_messages+        - Integer. How many messages to return. (optional, Default: 1)
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      # * +:decode+                    - Boolean. Boolean value indicating if the message should be base64 decoded.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/dd179474
      #
      # Returns a list of Azure::Storage::Entity::Queue::Message instances
      def list_messages(queue_name, visibility_timeout, options = {})
        number_of_messages = 1
        number_of_messages = options[:number_of_messages] if options[:number_of_messages]

        query = { "visibilitytimeout" => visibility_timeout.to_s, "numofmessages" => number_of_messages.to_s }
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        uri = messages_uri(queue_name, query)
        response = call(:get, uri, nil, {}, options)

        messages = Serialization.queue_messages_from_xml(response.body, options[:decode])
        messages
      end

      # Public: Adds a message to the queue and optionally sets a visibility timeout for the message.
      #
      # ==== Attributes
      #
      # * +queue_name+                 - String. The queue name.
      # * +message_id+                 - String. The id of the message.
      # * +pop_receipt+                - String. The valid pop receipt value returned from an earlier call to the Get Messages or
      #                                  update Message operation.
      # * +message_text+               - String. The message contents. Note that the message content must be in a format that may
      #                                  be encoded with UTF-8.
      # * +visibility_timeout+         - Integer. The new visibility timeout value, in seconds, relative to server time.
      # * +options+                    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      # * +:encode+                    - Boolean. If set to true, the message will be base64 encoded.
      # * +:timeout+                   - Integer. A timeout in seconds.
      # * +:request_id+                - String. Provides a client-generated, opaque value with a 1 KB character limit that is recorded
      #                                  in the analytics logs when storage analytics logging is enabled.
      #
      # See http://msdn.microsoft.com/en-us/library/azure/hh452234
      #
      # Returns a tuple of (pop_receipt, time_next_visible)
      # * pop_receipt        - String. The pop receipt of the queue message.
      # * time_next_visible  - String. A UTC date/time value that represents when the message will be visible on the queue.
      #
      # Remarks:
      #
      # An Update Message operation will fail if the specified message does not exist in the queue, or if the
      # specified pop receipt does not match the message.
      #
      # A pop receipt is returned by the Get Messages operation or the Update Message operation. Pop receipts
      # remain valid until one of the following events occurs:
      #
      # * The message has expired.
      #
      # * The message has been deleted using the last pop receipt received either from Get Messages or
      # Update Message.
      #
      # * The invisibility time has elapsed and the message has been dequeued by a Get Messages request. When
      # the invisibility time elapses, the message becomes visible again. If it is retrieved by another
      # Get Messages request, the returned pop receipt can be used to delete or update the message.
      #
      # * The message has been updated with a new visibility timeout. When the message is updated, a new pop
      # receipt will be returned.
      #
      # The Update Message operation can be used to continually extend the invisibility of a queue message. This
      # functionality can be useful if you want a worker role to "lease" a queue message. For example, if a worker
      # role calls Get Messages and recognizes that it needs more time to process a message, it can continually
      # extend the message's invisibility until it is processed. If the worker role were to fail during processing,
      # eventually the message would become visible again and another worker role could process it.
      #
      def update_message(queue_name, message_id, pop_receipt, message_text, visibility_timeout, options = {})
        query = { "visibilitytimeout" => visibility_timeout.to_s, "popreceipt" => pop_receipt }
        query["timeout"] = options[:timeout].to_s if options[:timeout]

        uri = message_uri(queue_name, message_id, query)
        body = Serialization.message_to_xml(message_text, options[:encode])

        response = call(:put, uri, body, {}, options)
        new_pop_receipt = response.headers["x-ms-popreceipt"]
        time_next_visible = response.headers["x-ms-time-next-visible"]
        return new_pop_receipt, time_next_visible
      end

      # Protected: Generate the URI for the collection of queues.
      #
      # ==== Attributes
      #
      # * +query+      - A Hash of query parameters (default: {}).
      #
      # Returns a URI.
      protected
        def collection_uri(query = {}, options = {})
          query.update(comp: "list", include: "metadata")
          generate_uri("", query, options)
        end

      # Protected: Generate the URI for a given queue.
      #
      # ==== Attributes
      #
      # * +queue_name+ - The name of the queue.
      # * +query+      - A Hash of query parameters (default: {}).
      #
      # Returns a URI.
      protected
        def queue_uri(queue_name, query = {}, options = {})
          return queue_name if queue_name.kind_of? ::URI
          generate_uri(queue_name, query, options)
        end

      # Protected: Generate the messages URI for the given queue.
      #
      # ==== Attributes
      #
      # * +queue_name+ - The name of the queue.
      # * +query+      - A Hash of query parameters (default: {}).
      #
      # Returns a URI.
      protected
        def messages_uri(queue_name, query = {}, options = {})
          generate_uri("#{queue_name}/messages", query, options)
        end

      # Protected: Generate the URI for a given message
      #
      # ==== Attributes
      #
      # * +queue_name+ - The name of the queue.
      # * +message_id+ - The id of the message.
      # * +query+      - A Hash of query parameters (default: {}).
      #
      # Returns a URI.
      protected
        def message_uri(queue_name, message_id, query = {}, options = {})
          generate_uri("#{queue_name}/messages/#{message_id}", query, options)
        end

      protected
        def call(method, uri, body = nil, headers = {}, options = {})
          headers["x-ms-version"] = @api_version ? @api_version : Default::STG_VERSION
          headers["User-Agent"] = @user_agent_prefix ? "#{@user_agent_prefix}; #{Default::USER_AGENT}" : Default::USER_AGENT
          super
        end
    end
  end
end

Azure::Storage::QueueService = Azure::Storage::Queue::QueueService
