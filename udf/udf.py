import re
from datetime import datetime
from arrow_udf import udf, udtf, UdfServer

@udf(input_types=["VARCHAR", "VARCHAR"], result_type="VARCHAR")
def mask_pii(data: str, data_type: str) -> str:
    """
    Mask sensitive PII data types according to international privacy standards.

    Args:
        data (str): The original value to mask.
        data_type (str): One of 'email', 'phone', 'address', 'name', 'passport', 
                        'national_id', 'credit_card', 'ssn', 'dob'.

    Returns:
        str: Masked value
    """
    data_type = data_type.lower()

    if data_type == "email":
        name, domain = data.split('@')
        if len(name) <= 2:
            masked_name = name[0] + "*"
        else:
            masked_name = name[0] + "*" * (len(name)-2) + name[-1]
        return f"{masked_name}@{domain}"

    elif data_type in ["telp", "phone", "telephone"]:
        digits = re.sub(r'\D', '', data)
        return "*" * (len(digits) - 4) + digits[-4:] if len(digits) > 4 else "*" * len(digits)

    elif data_type == "address":
        parts = data.split(',')
        return "*****, " + ', '.join(p.strip() for p in parts[1:]) if len(parts) > 1 else "*****"

    elif data_type == "name":
        words = data.split()
        masked = [w[0] + "*" * (len(w)-1) if len(w) > 1 else w for w in words]
        return ' '.join(masked)

    elif data_type == "passport":
        return data[0] + "*" * (len(data) - 2) + data[-1] if len(data) > 2 else "*" * len(data)

    elif data_type == "national_id":
        return "*" * (len(data) - 4) + data[-4:] if len(data) > 4 else "*" * len(data)

    elif data_type == "credit_card":
        digits = re.sub(r'\D', '', data)
        return "*" * 12 + digits[-4:] if len(digits) >= 16 else "*" * (len(digits) - 4) + digits[-4:]

    elif data_type == "ssn":
        digits = re.sub(r'\D', '', data)
        return "***-**-" + digits[-4:] if len(digits) == 9 else "*" * len(digits)

    elif data_type == "dob":
        # Masking full DOB, keep year only
        try:
            dob = datetime.strptime(data, "%Y-%m-%d")
            return f"****-**-{dob.year}"
        except ValueError:
            return "****-**-****"

    else:
        raise ValueError("Unsupported data type.")

# ✅ Example Usage
print(mask_pii("johndoe@example.com", "email"))            # j*****e@example.com
print(mask_pii("+62 812-3456-7890", "phone"))              # **********7890
print(mask_pii("123 Main St, Jakarta, Indonesia", "address"))  # *****, Jakarta, Indonesia
print(mask_pii("John Doe", "name"))                        # J*** D**
print(mask_pii("A1234567", "passport"))                    # A******7
print(mask_pii("123456789", "national_id"))                # *****6789
print(mask_pii("4111 1111 1111 1234", "credit_card"))      # ************1234
print(mask_pii("123-45-6789", "ssn"))                      # ***-**-6789
print(mask_pii("1990-05-20", "dob"))                       # ****-**-1990


if __name__ == '__main__':
    # Create a UDF server and register the functions
    server = UdfServer(location="0.0.0.0:8815") # You can use any available port in your system. Here we use port 8815.
    server.add_function(mask_pii)
    # Start the UDF server
    server.serve()