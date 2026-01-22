package com.codetikki.crud.service;

import com.codetikki.crud.dao.UserDao;
import com.codetikki.crud.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserDao userDao;

    public User createUser(User user) {
        if (user.getEmailId() == null || user.getEmailId().isEmpty()) {
            throw new IllegalArgumentException("Email ID cannot be null or empty");
        }
        return userDao.save(user);
    }

    public List<User> getAllUsers() {
        return userDao.findAll();
    }

    public Optional<User> getUserById(Long id) {
        return userDao.findById(id);
    }

    public User updateUser(Long id, User userDetails) {
        Optional<User> optionalUser = userDao.findById(id);
        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            user.setName(userDetails.getName());
            user.setEmailId(userDetails.getEmailId());
            user.setWhatsappNumber(userDetails.getWhatsappNumber());
            user.setGender(userDetails.getGender());
            return userDao.save(user);
        } else {
            throw new RuntimeException("User not found with id: " + id);
        }
    }

    public void deleteUser(Long id) {
        userDao.deleteById(id);
    }
}
