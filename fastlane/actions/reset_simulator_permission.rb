require "sqlite3"

module Fastlane
  module Actions
    module SharedValues
      RESET_SIMULATOR_PERMISSION_CUSTOM_VALUE = :RESET_SIMULATOR_PERMISSION_CUSTOM_VALUE
    end

    # To share this integration with the other fastlane users:
    # - Fork https://github.com/fastlane/fastlane/tree/master/fastlane
    # - Clone the forked repository
    # - Move this integration into lib/fastlane/actions
    # - Commit, push and submit the pull request

    class ResetSimulatorPermissionAction < Action
      @simulators = sh "xcrun instruments -s | grep Simulator"

      def self.run(params)
        UI.message "Searching the ID of " + params[:device] + " ("+ params[:os] +") simulator ..."
        simulator_name = params[:device] + " ("+ params[:os] +")"
        simulator_id = ''
        @simulators.each_line { |line|
          if line.index(simulator_name) != nil
            simulator_id = line[/#{Regexp.escape("[")}(.*?)#{Regexp.escape("]")}/m, 1]
          end
        }
        simulator_directory = File.expand_path("~/Library/Developer/CoreSimulator/Devices/" + simulator_id + "/data/Library/TCC")
        tcc_db_file = simulator_directory + "/TCC.db"
        if File.exist?(tcc_db_file)
          db = SQLite3::Database.new tcc_db_file

          accessTypes = params[:access]
          if accessTypes.include? 'all'
            accessTypes = ['address_book', 'photos', 'calendar', 'home_kit']
          end
          accessTypes.each { |access|
            accessTypeKey = 'kTCCServicePhotos'
            case access
              when "address_book"
                accessTypeKey = 'kTCCServiceAddressBook'
              when "calendar"
                accessTypeKey = 'kTCCServiceCalendar'
              when "home_kit"
                accessTypeKey = "kTCCServiceWillow"
            end
            query = "SELECT * FROM access WHERE service=\""+accessTypeKey+"\" AND client=\""+params[:app_identifier]+"\""
            row = db.get_first_row query
            if row
              UI.message "Reseting "+access+" permission to " + params[:app_identifier] + " in " + params[:device] + " ("+ params[:os] +") simulator ..."
              db.execute("DELETE FROM access WHERE service=\""+accessTypeKey+"\" AND client=\""+params[:app_identifier]+"\"")
            end
          }
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Reset iOS permissions for the app in iPhone Simulator"
      end

      def self.details
        "By reseting the iOS permissions in the iPhone Simulator, the app will be prompted to allow a certain permission, specifically, Photos, Calendar, Address Book, and HomeKit permissions."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :device,
                                       env_name: "FL_RESET_SIMULATOR_PERMISSION_DEVICE",
                                       description: "Device to reset permission",
                                       default_value: 'all',
                                       verify_block: proc do |value|
                                         allowedDevices = []
                                         @simulators.each_line { |line| allowedDevices.push(line.split('(').first.strip!) }
                                         allowedDevices.uniq!
                                         UI.user_error!("Valid values for 'device': \n\t- " + allowedDevices.join("\n\t- ")) unless (allowedDevices.include? value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :os,
                                       env_name: "FL_RESET_SIMULATOR_PERMISSION_OS",
                                       description: "OS of device to reset",
                                       is_string: true,
                                       verify_block: proc do |value|
                                         versions = []
                                         @simulators.each_line { |line| versions.push(line[/#{Regexp.escape("(")}(.*?)#{Regexp.escape(")")}/m, 1]) }
                                         versions.uniq!
                                         UI.user_error!("Valid values for 'os': \n\t- " + versions.join("\n\t- ")) unless (versions.include? value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :access,
                                       env_name: "FL_RESET_SIMULATOR_PERMISSION_ACCESS",
                                       description: "Access type to reset",
                                       type: Array,
                                       verify_block: proc do |values|
                                         allowedAccessTypes = ['address_book', 'photos', 'calendar', 'home_kit', 'all']
                                         values.each { |value| UI.user_error!("Valid values for 'access': \n\t- " + allowedAccessTypes.join("\n\t- ")) unless (allowedAccessTypes.include? value) }
                                       end),
          FastlaneCore::ConfigItem.new(key: :app_identifier,
                                       env_name: "FL_RESET_SIMULATOR_PERMISSION_APP_IDENTIFIER",
                                       description: "App identifier",
                                       default_value: CredentialsManager::AppfileConfig.try_fetch_value(:app_identifier)
                                       )
        ]
      end

      def self.authors
        ["@nicnocquee"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
