import requests
import time
import re
import csv

# Danh sách thuộc tính được hardcode
attributes = ["Active connections", "Reading", "Writing", "Waiting"]

def poll_nginx_status(url, output_file, interval=5):
    # Khởi tạo file CSV và viết tiêu đề
    with open(output_file, "w", newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['time'] + attributes)

    while True:
        try:
            response = requests.get(url)
            if response.status_code == 200:
                # Lưu trữ các giá trị thuộc tính đã tìm thấy
                found_attributes = {}
                
                for attribute in attributes:
                    # Sử dụng Regular Expression để tìm kiếm mỗi thuộc tính
                    pattern = rf"{attribute}:\s+(\d+)"
                    match = re.search(pattern, response.text)
                    if match:
                        found_attributes[attribute] = match.group(1)
                
                # Ghi các giá trị thuộc tính vào file CSV
                with open(output_file, "a", newline='') as f:
                    writer = csv.writer(f)
                    row = [time.time()] + [found_attributes.get(attr, "N/A") for attr in attributes]
                    writer.writerow(row)
            else:
                print(f"Failed to get nginx status, status code: {response.status_code}")
        except Exception as e:
            print(f"An error occurred: {e}")

        time.sleep(interval)

if __name__ == "__main__":
    url = "http://localhost/nginx_status"  # Sửa URL này theo cấu hình của bạn
    output_file = "nginx_attributes.csv"  # Sửa tên file output này nếu bạn muốn
    interval = 5  # Sửa khoảng thời gian này nếu bạn muốn
    poll_nginx_status(url, output_file, interval)

