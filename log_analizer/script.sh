LOG_FILE="sample_log.log"


filter_by_date() {
    echo "Enter the date (YYYY-MM-DD):"
    read date
    grep "$date" $LOG_FILE
}

filter_by_severity() {
    echo "Choose severity level: (ERROR, WARNING, INFO):"
    echo "1 - ERROR"
    echo "2 - WARNING"
    echo "3 - INFO"
    echo "4 - ALL"
    read severity
        case $severity in 
        1) 
            grep -i "ERROR" $LOG_FILE
        ;;
        2)
            grep -i "WARNING" $LOG_FILE
        ;;
        3)
            grep -i "INFO" $LOG_FILE
        ;;
        4)  
            grep -i "" $LOG_FILE
        ;;
        5) 
            exit 0 ;;
        esac
}       

filter_by_keyword() {
    echo "Enter keyword:"
    read keyword
    grep -i "$keyword" $LOG_FILE
}

generate_summary() {
    echo "Summary of log entries by severity:"
    echo "ERROR: $(grep -c 'ERROR' $LOG_FILE)"
    echo "WARNING: $(grep -c 'WARNING' $LOG_FILE)"
    echo "INFO: $(grep -c 'INFO' $LOG_FILE)"
}

save_filtered_results() {
    echo "Enter file name to save results:"
    read filename
    echo "1 - ERROR"
    echo "2 - WARNING"
    echo "3 - INFO"
    echo "4 - ALL"
    filter_by_severity > "$filename"  # Example: modify based on user input
    echo "Results saved to $filename."
}


while true; do
    echo "Choose an option:"
    echo "1) Filter by Date"
    echo "2) Filter by Severity Level"
    echo "3) Filter by Keyword"
    echo "4) Generate Summary"
    echo "5) Save Filtered Results"
    echo "6) Exit"
    read choice

    case $choice in
        1) filter_by_date ;;
        2) filter_by_severity ;;
        3) filter_by_keyword ;;
        4) generate_summary ;;
        5) save_filtered_results ;;
        6) exit 0 ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
