// F3A Microservice Client for GitHub Pages
// Add this to your GitHub Pages site

const API_BASE = 'https://app.f3a-pattern-aerobatics-rc.club:30080';

class F3AClient {
  async fetchClubInfo() {
    try {
      const response = await fetch(`${API_BASE}/api/club`);
      return await response.json();
    } catch (error) {
      console.error('Failed to fetch club info:', error);
      return null;
    }
  }

  async fetchEvents() {
    try {
      const response = await fetch(`${API_BASE}/api/events`);
      return await response.json();
    } catch (error) {
      console.error('Failed to fetch events:', error);
      return null;
    }
  }

  async fetchAircraft() {
    try {
      const response = await fetch(`${API_BASE}/api/aircraft`);
      return await response.json();
    } catch (error) {
      console.error('Failed to fetch aircraft:', error);
      return null;
    }
  }

  async checkHealth() {
    try {
      const response = await fetch(`${API_BASE}/health`);
      return await response.json();
    } catch (error) {
      console.error('Health check failed:', error);
      return null;
    }
  }
}

// Usage example
const f3a = new F3AClient();

// Load club info on page load
document.addEventListener('DOMContentLoaded', async () => {
  const clubInfo = await f3a.fetchClubInfo();
  if (clubInfo) {
    document.getElementById('club-name').textContent = clubInfo.name;
    document.getElementById('club-description').textContent = clubInfo.description;
  }

  const events = await f3a.fetchEvents();
  if (events) {
    const eventsList = document.getElementById('events-list');
    events.upcoming.forEach(event => {
      const li = document.createElement('li');
      li.innerHTML = `<strong>${event.title}</strong> - ${event.date} at ${event.time}`;
      eventsList.appendChild(li);
    });
  }
});
