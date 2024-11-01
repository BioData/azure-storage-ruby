# frozen_string_literal: true

#-------------------------------------------------------------------------
# # Copyright (c) Microsoft and contributors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------
require "azure/core/http/http_filter"

module Azure
  module Core
    module Http
      # A HttpFilter implementation that handles retrying based on a
      # specific policy when HTTP layer errors occur
      class RetryPolicy < HttpFilter
        def initialize(&block)
          @block = block
          @retry_data = {}
        end

        attr_accessor :retry_data

        # Overrides the base class implementation of call to implement
        # a retry loop that uses should_retry? to determine when to
        # break the loop
        #
        # req   - HttpRequest. The HTTP request
        # _next - HttpFilter. The next filter in the pipeline
        def call(req, _next)
          response = nil
          retry_data = @retry_data.dup
          begin
            # URI could change in the retry, e.g. secondary endpoint
            unless retry_data[:uri].nil?
              req.uri = retry_data[:uri]
            end

            retry_data[:error] = nil
            response = _next.call
          rescue
            retry_data[:error] = $!
          end while should_retry?(response, retry_data)

          # Assign the error when HTTP error is not thrown from the previous filter
          retry_data[:error] = response.error if response && !response.success?
          if retry_data[:error].nil?
            response
          else
            raise retry_data[:error]
          end
        end

        # Determines if the HTTP request should continue retrying
        #
        # response - HttpResponse. The response from the active request
        # retry_data - Hash. Stores stateful retry data
        #
        # The retry_data is a Hash which can be used to store
        # stateful data about the request execution context (such as an
        # incrementing counter, timestamp, etc). The retry_data object
        # will be the same instance throughout the lifetime of the request.
        #
        # If an inline block was passed to the constructor, that block
        # will be used here and should return true to retry the job, or
        # false to stop exit. If an inline block was not passed to the
        # constructor the method returns false.
        #
        # Alternatively, a subclass could override this method.
        def should_retry?(response, retry_data)
          @block ? @block.call(response, retry_data) : false
        end
      end
    end
  end
end
