module Dde

  # Class encapsulates DDE string. In addition to normal string behavior,
  # it also has *handle* that can be passed to dde functions
  class DdeString < String
    include Win::Dde

    attr_accessor :handle, # string handle passable to DDEML functions
                  :instance_id, # instance id of DDE app that created this DdeString
                  :code_page, # Windows code page for this string (CP_WINANSI or CP_WINUNICODE)
                  :name # ORIGINAL string used to create this DdeString

    # Given the DDE application instance_id, you cane create DdeStrings
    # either from regular string or from known DdeString handle
    def initialize(instance_id, string_or_handle, code_page=CP_WINANSI)
      @instance_id = instance_id
      @code_page = code_page

      begin
        if string_or_handle.is_a? String
          @name = string_or_handle
          error unless @handle = dde_create_string_handle(@instance_id, @name, @code_page)
        else
          @handle = string_or_handle
          error unless @name = dde_query_string(@instance_id, @handle, @code_page)
        end
      rescue => e
      end
      raise Dde::Errors::StringError, "Failed to initialize DDE string: #{e} #{e.backtrace.join("\n")}" unless @handle && @name && !e
      super @name
    end
  end
end