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
require 'azure/core/filtered_service'
require 'azure/core/http/signer_filter'
require 'azure/core/auth/shared_key'

module Azure
  module Core
    # A base class for Service implementations
    class SignedService < FilteredService
      # Create a new instance of the SignedService
      #
      # @param signer         [Azure::Core::Auth::Signer]. An implementation of Signer used for signing requests. (optional, Default=Azure::Core::Auth::SharedKey.new)
      # @param account_name   [String] The account name (optional, Default=Azure.config.storage_account_name)
      # @param options        [Hash] options
      def initialize(signer = nil, account_name = nil, options = {})
        super('', options)
        signer ||= Core::Auth::SharedKey.new(client.storage_account_name, client.storage_access_key)
        @account_name = account_name || client.storage_account_name
        @signer = signer
        filters.unshift Core::Http::SignerFilter.new(signer) if signer
      end

      attr_accessor :account_name
      attr_accessor :signer

      def call(method, uri, body = nil, headers = nil, options = {})
        super(method, uri, body, headers, options)
      end
    end
  end
end
