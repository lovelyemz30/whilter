const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const md5 = require('md5');
const mysql = require('mysql');

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// MySQL Database Connection Configuration
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'myapp',
});

// Connect to MySQL
db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL database:', err);
    } else {
        console.log('Connected to MySQL database');
    }
});
app.post('/login', (req, res) => {
    const { user_email, user_password } = req.body;

    const hashedPassword = md5(user_password);

    // Check if the email and password match
    db.query(
        'SELECT * FROM users WHERE user_email = ? AND user_password = ?',
        [user_email, hashedPassword],
        (err, results) => {
            if (err) {
                console.error('Error querying database:', err);
                return res.status(500).json({ success: false, message: 'Internal Server Error' });
            }

            if (results.length > 0) {
                const userDetails = results[0];
                res.json({ success: true, userData: userDetails });
            } else {
                res.json({ success: false });
            }
        }
    );
});

// Endpoint to handle user registration
app.post('/signup', (req, res) => {
    const { user_name, user_email, user_password } = req.body;

    // Check if the email already exists
    db.query('SELECT * FROM users WHERE user_email = ?', [user_email], (err, results) => {
        if (err) {
            console.error('Error querying database:', err);
            return res.status(500).json({ success: false, message: 'Internal Server Error' });
        }

        if (results.length > 0) {
            return res.status(400).json({ success: false, message: 'Email already exists' });
        }

        // Create a new user
        const newUser = {
            user_name,
            user_email,
            user_password: md5(user_password),
        };

        // Insert the new user into the database
        db.query('INSERT INTO users SET ?', newUser, (err, result) => {
            if (err) {
                console.error('Error inserting user into database:', err);
                return res.status(500).json({ success: false, message: 'Internal Server Error' });
            }

            res.json({ success: true, message: 'User created successfully' });
        });
    });
});

// Endpoint to validate email existence
app.post('/validate_email', (req, res) => {
    const { email } = req.body;

    // Check if the email exists
    db.query('SELECT * FROM users WHERE user_email = ?', [email], (err, results) => {
        if (err) {
            console.error('Error querying database:', err);
            return res.status(500).json({ success: false, message: 'Internal Server Error' });
        }

        res.json({ emailFound: results.length > 0 });
    });
});
app.post('/admin/login', (req, res) => {
    const { admin_email, admin_password } = req.body;

    db.query(
        'SELECT * FROM admin WHERE admin_email = ? AND admin_password = ?',
        [admin_email, admin_password],
        (error, results) => {
            if (error) {
                res.json({ success: false });
            } else if (results.length > 0) {
                res.json({ success: true, adminData: results[0] });
            } else {
                res.json({ success: false });
            }
        }
    );
});


// Get All Items API
app.get('/api/getAllItems', (req, res) => {
    const query = 'SELECT * FROM items ORDER BY item_id DESC';

    db.query(query, (err, result) => {
        if (err) {
            console.error('Error getting all items:', err);
            res.json({ success: false });
        } else {
            const itemsDetails = result.map(row => ({ ...row }));
            console.log('Items Details:', itemsDetails);
            res.json({ success: true, clothItemsData: itemsDetails });

        }
    });
});




// Add Item API
app.post('/api/addItem', (req, res) => {
    const { name, price, size, description, image } = req.body;
    const query = 'INSERT INTO items SET ?';
    const values = {
        name,
        price,
        size,
        description,
        image,
    };

    db.query(query, values, (err, result) => {
        if (err) {
            console.error('Error adding item:', err);
            res.json({ success: false, message: 'Error creating item' });
        } else {
            res.json({ success: true, message: 'Item created successfully' });
        }
    });
});
app.patch('/api/updateItem/:itemId', (req, res) => {
    const itemId = req.params.itemId;
    const { name, price, description, size } = req.body;

    const sql = 'UPDATE items SET name=?, price=?, description=?, size=? WHERE item_id=?';
    db.query(sql, [name, price, description, size, itemId], (err, result) => {
        if (err) throw err;
        res.json({ success: true });
    });
});
app.patch('/api/updateItem/:itemId', (req, res) => {
    const itemId = req.params.itemId;
    const { name, price, description, size } = req.body;

    const sql = 'UPDATE items SET name=?, price=?, description=?, size=? WHERE item_id=?';
    db.query(sql, [name, price, description, size, itemId], (err, result) => {
        if (err) {
            console.error('Error updating item:', err);
            res.json({ success: false, message: 'Error updating item' });
        } else {
            res.json({ success: true, message: 'Item updated successfully' });
        }
    });
});

// Delete Item API
app.delete('/api/deleteItem/:itemId', (req, res) => {
    const itemId = req.params.itemId;

    const sql = 'DELETE FROM items WHERE item_id=?';
    db.query(sql, [itemId], (err, result) => {
        if (err) {
            console.error('Error deleting item:', err);
            res.json({ success: false, message: 'Error deleting item' });
        } else {
            res.json({ success: true, message: 'Item deleted successfully' });
        }
    });
});

// Endpoint to get all users
app.get('/api/getAllUsers', (req, res) => {
    const query = 'SELECT * FROM users';

    db.query(query, (err, result) => {
        if (err) {
            console.error('Error getting all users:', err);
            res.json({ success: false, error: err.message });
        } else {
            const usersDetails = result.map(row => ({ ...row }));
            res.json({ success: true, usersData: usersDetails });
        }
    });
});

app.post('/api/addToCart', (req, res) => {
    const { userId, itemId, size, quantity } = req.body;

    const sql = 'INSERT INTO cart (user_id, item_id, size,  quantity) VALUES (?, ?,  ?, ?)';
    const values = [userId, itemId, size, quantity];

    db.query(sql, values, (error, result) => {
        if (error) {
            console.error('Error adding item to cart: ', error);
            res.status(500).json({ success: false, message: 'Internal Server Error' });
        } else {
            res.json({ success: true, message: 'Item added to cart successfully' });
        }
    });
});

app.post('/placeOrder', (req, res) => {
    const {
        user_id,
        deliveryAddress,
        cartDetails,
        shippingOption,
        orderTotal,
        paymentOption,
        paymentDetails,
        totalPayment,
        phoneNumber,
        parcelName,
    } = req.body;

    if (!user_id || typeof user_id !== 'number') {
        return res.status(400).json({ error: 'Invalid user_id' });
    }

    // ... other existing validation

    const insertOrderSql =
        'INSERT INTO orders (user_id, delivery_address, cart_details, shipping_option, order_total, payment_option, payment_details, total_payment, phone_number, parcel_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
    const orderValues = [
        user_id,
        deliveryAddress,
        JSON.stringify(cartDetails),
        shippingOption,
        orderTotal,
        paymentOption,
        paymentDetails,
        totalPayment,
        phoneNumber,
        parcelName,
    ];

    db.query(insertOrderSql, orderValues, (err, result) => {
        if (err) {
            console.error('Error inserting order: ' + err.message);
            return res.status(500).json({ error: 'Error placing order' });
        }

        const orderId = result.insertId;

        // Update item quantities in the database
        cartDetails.forEach(item => {
            const updateQuantitySql = 'UPDATE items SET quantity = quantity - ? WHERE item_id = ?';
            const updateQuantityValues = [item.quantity, item.item_id];

            db.query(updateQuantitySql, updateQuantityValues, (err) => {
                if (err) {
                    console.error('Error updating item quantity: ' + err.message);
                    return res.status(500).json({ error: 'Error updating item quantity' });
                }
            });
        });

        console.log('Order placed successfully');
        res.json({ success: true, orderId });
    });
});


app.get('/userOrders/:userId', (req, res) => {
    const userId = req.params.userId;

    const sql = 'SELECT * FROM orders WHERE user_id = ?';
    db.query(sql, [userId], (err, result) => {
        if (err) {
            console.error('Error fetching orders:', err.message);
            res.status(500).json({ error: 'Error fetching orders' });
        } else {
            res.json(result);
        }
    });
});
app.get('/orders', (req, res) => {
    // Use parameterized queries to prevent SQL injection
    const query = 'SELECT * FROM orders';

    // Execute the query with error handling
    db.query(query, (err, results) => {
        if (err) {
            // Log the error for debugging purposes
            console.error('Error executing query:', err);

            // Send a 500 Internal Server Error response
            return res.status(500).json({ error: 'Internal Server Error' });
        }

        // Send a JSON response with the results
        res.json(results);
    });
});



app.patch('/api/orders/:orderId/status', (req, res) => {
    const orderId = req.params.orderId;
    const newStatus = req.body.status;

    if (!orderId || !newStatus) {
        return res.status(400).json({ error: 'Both orderId and status are required in the request body.' });
    }

    const query = 'UPDATE orders SET status = ? WHERE order_id = ?';

    db.query(query, [newStatus, orderId], (err, results) => {
        if (err) {
            console.error('Error updating order status:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.affectedRows === 0) {
            return res.status(404).json({ error: 'Order not found' });
        }

        res.json({ message: 'Order status updated successfully' });
    });

});

app.get('/api/getAvailableQuantity', (req, res) => {
    const itemId = parseInt(req.query.itemId, 10);

    const query = 'SELECT availableQuantity FROM items WHERE itemId = ?';
    connection.query(query, [itemId], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            res.json({
                success: false,
                message: 'Error retrieving available quantity',
            });
            return;
        }

        if (results.length > 0) {
            res.json({
                success: true,
                availableQuantity: results[0].availableQuantity,
            });
        } else {
            res.json({
                success: false,
                message: 'Item not found',
            });
        }
    });
});

// Add quantity API
app.post('/api/addQuantity', (req, res) => {
    const { itemId } = req.body;

    if (!itemId) {
        return res.status(400).json({ success: false, message: 'Item ID is required' });
    }

    db.query('UPDATE items SET quantity = quantity + 1 WHERE item_id = ?', [itemId], (err, result) => {
        if (err) {
            console.error('Error adding quantity:', err);
            return res.status(500).json({ success: false, message: 'Internal server error' });
        }

        return res.json({ success: true, message: 'Quantity added successfully' });
    });
});

// Subtract quantity API
app.post('/api/subtractQuantity', (req, res) => {
    const { itemId } = req.body;

    if (!itemId) {
        return res.status(400).json({ success: false, message: 'Item ID is required' });
    }

    db.query('UPDATE items SET quantity = GREATEST(quantity - 1, 0) WHERE item_id = ?', [itemId], (err, result) => {
        if (err) {
            console.error('Error subtracting quantity:', err);
            return res.status(500).json({ success: false, message: 'Internal server error' });
        }

        return res.json({ success: true, message: 'Quantity subtracted successfully' });
    });
});

// Endpoint to get counts and sum
app.get('/api/getCountsAndSum', (req, res) => {
    // Count all users
    const countUsersQuery = 'SELECT COUNT(*) AS totalUsers FROM users';
    // Count all orders
    const countOrdersQuery = 'SELECT COUNT(*) AS totalOrders FROM orders';
    // Count all items
    const countItemsQuery = 'SELECT COUNT(*) AS totalItems FROM items';
    // Sum of total_payment in the orders table
    const sumTotalPaymentQuery = 'SELECT SUM(total_payment) AS totalPaymentSum FROM orders';

    // Execute the queries in parallel
    db.query(countUsersQuery, (err, usersResult) => {
        if (err) {
            return res.status(500).json({ success: false, error: 'Error counting users' });
        }

        db.query(countOrdersQuery, (err, ordersResult) => {
            if (err) {
                return res.status(500).json({ success: false, error: 'Error counting orders' });
            }

            db.query(countItemsQuery, (err, itemsResult) => {
                if (err) {
                    return res.status(500).json({ success: false, error: 'Error counting items' });
                }

                db.query(sumTotalPaymentQuery, (err, sumResult) => {
                    if (err) {
                        return res.status(500).json({ success: false, error: 'Error calculating total payment sum' });
                    }

                    const countsAndSum = {
                        totalUsers: usersResult[0].totalUsers,
                        totalOrders: ordersResult[0].totalOrders,
                        totalItems: itemsResult[0].totalItems,
                        totalPaymentSum: sumResult[0].totalPaymentSum || 0,
                    };

                    res.json({ success: true, countsAndSum });
                });
            });
        });
    });
});


app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
