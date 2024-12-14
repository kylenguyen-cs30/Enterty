import Foundation

enum DateUtils {
    // Static property for ISO8601 date parsing, configure
    // specific options
    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withYear, // Include year
            .withMonth, // Include month
            .withDay, // Include Day
            .withTime, // Include time
            .withDashSeparatorInDate, // Use Dash
            .withColonSeparatorInTime, // Use Colon
            .withFractionalSeconds, // Include Fractional seconds
        ]
        return formatter
    }()

    // Static property for displaying dates in the a specific format
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none // Do not include time in the displayed format
        formatter.doesRelativeDateFormatting = true // Use relative dates
        return formatter
    }()

    // Func to format a date string from ISO8601 to a readable string
    static func formatDate(_ dateString: String) -> String {
        print("Attempting to format date: \(dateString)")
        guard let date = iso8601Formatter.date(from: dateString) else {
            print("❌ Failed to parse date: \(dateString)")
            return dateString // Return the original string if parsing failed
        }
        let formatted = displayFormatter.string(from: date)
        print("✅ Successfully formatted date to: \(formatted)")
        return formatted
    }

    // Function to calculate the number of days between a given date and now
    static func daysSince(_ dateString: String) -> Int? {
        guard let date = iso8601Formatter.date(from: dateString) else {
            return nil
        }

        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)
        return components.day
    }

    // Func to determine the completion status of a tracked titlte based on its end date
    static func completionStatus(for trackedTitle: TrackedTitle) -> String {
        guard trackedTitle.status == "finished",
              let dateEnded = trackedTitle.date_ended
        else {
            return "" // return an empty string if the status is not finding
        }

        let formattedDate = formatDate(dateEnded)

        if let days = daysSince(dateEnded) {
            switch days {
            case 0:
                return "Completed today"
            case 1:
                return "Completed yesterday"
            default:
                return "Completed \(formattedDate)"
            }
        }

        // NOTE: Return formatterd day
        return "Completed \(formattedDate)"
    }
}
