// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
  const loginForm = document.getElementById('loginForm');

  if (loginForm) {
    loginForm.addEventListener('submit', (event) => {
      event.preventDefault();

      // Add small delay to ensure form values are captured properly
      setTimeout(() => {
        const voter_id = document.getElementById('voter-id').value;
        const password = document.getElementById('password').value;
        const token = voter_id;

        console.log('Submitting login with:', { voter_id, password: password ? '***' : 'EMPTY' });

        if (!voter_id || !password) {
          console.error('Voter ID and password are required');
          alert('Please enter both Voter ID and password');
          return;
        }

        const headers = {
          'method': "GET",
          'Authorization': `Bearer ${token}`,
        };

        fetch(`http://127.0.0.1:8000/login?voter_id=${voter_id}&password=${password}`, { headers })
        .then(response => {
          console.log('Response status:', response.status);
          if (response.ok) {
            return response.json();
          } else {
            throw new Error('Login failed');
          }
        })
        .then(data => {
          console.log('Login successful, role:', data.role);
          if (data.role === 'admin') {
            localStorage.setItem('jwtTokenAdmin', data.token);
            window.location.replace(`http://127.0.0.1:8080/admin.html?Authorization=Bearer ${localStorage.getItem('jwtTokenAdmin')}`);
          } else if (data.role === 'user'){
            localStorage.setItem('jwtTokenVoter', data.token);
            window.location.replace(`http://127.0.0.1:8080/index.html?Authorization=Bearer ${localStorage.getItem('jwtTokenVoter')}`);
          }
        })
        .catch(error => {
          console.error('Login failed:', error.message);
          alert('Login failed: ' + error.message);
        });
      }, 100); // Small delay to ensure form values are captured
    });
  } else {
    console.error('Login form not found');
  }
});
