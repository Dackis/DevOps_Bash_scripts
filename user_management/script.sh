#!/bin/bash

create_user () {
    echo "Insert username"
    read username
    echo "Enter password (leave blank for default):"
    read -s password

    sudo useradd -m -s /bin/bash $username
    if [[ -n "$password" ]]; then
        echo "$username:$password" | sudo chpasswd
    fi
    echo "User $username added successfully."
}

delete_user () {
    echo "Insert username to delete: "
    read username

    echo "Do you want to delete home folder and mail spool?"
    echo "1 - Yes"
    echo "2 - No"
    read choice
case $choice in
    1) 
    sudo userdel -r $username
    ;;
    2)
    sudo userdel $username
    ;;
    *)
    Echo "Invalid input"
    ;;
esac
}

modify_user () {
    echo "Insert username which you want to mod"
    read username
    echo "choose what you want to change"
    echo "1 - change shell"
    echo "2 - change home directory"
    echo "3 - change password"
    echo "4 - exit"
    read choice


    case $choice in
    1)
    echo "Write shell you want to change to:"
    read shell
    sudo usermod -s $shell $username 
    echo "User - $username , changed shell to $shell"
    ;;
    2) 
    echo "Write home directory you want to change for the user"
    read home_dir
    sudo usermod -d $home_dir $username
    echo "User - $username, changed homedir to $home_dir"
    ;;
    3)
    echo "Write password you want change for the user"
    sudo passwd $username 
    ;;
    4)
    exit
    ;;
    *) 
    echo "Invalid choice"
    ;;
    esac
}
generate_report() {
    echo -e "Username\tUID\tHome Directory\tShell"
    awk -F: '{ print $1 "\t" $3 "\t" $6 "\t" $7 }' /etc/passwd
}

    


while true; do
    echo "1 - Create user"
    echo "2 - Remove user"
    echo "3 - Modify user"
    echo "4 - Generate user report"
    echo "5 - Exit"
    read choice

case $choice in
    1) 
    create_user
    ;;
    2)
    delete_user
    ;;
    3)
    modify_user
    ;;
    4)
    generate_report
    ;;
    5)
    exit 
    ;;
esac
done
