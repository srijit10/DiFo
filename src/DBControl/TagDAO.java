/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DBControl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import constants.Constants;
import model.Tag;

/**
 * Data Access Object for Tag
 * @author arka
 */
public class TagDAO {
    private final String TABLE = Constants.DB_TABLE_TAG;
    private final Connection connection;
    
    /**
     * Constructor method
     * @param connection 
     */
    public TagDAO(Connection connection) {
        this.connection = connection;
    }
    
    /**
     * Method to insert a tag in database
     * @param tags all tags
     */
    public void insertTag(String tags, int qid) {
        String names[] = tags.split(" ");
        for (String name : names) {
            name = name.toLowerCase();
            if(name.length() > 20) {
                continue;
            }
            
            try {
                // check if tag is already in db
                int tid = this.getIdByTag(name);
                if (tid != -99) {
                    QuestionsTagDAO questionTagDAO = new 
                        QuestionsTagDAO(connection);
                    questionTagDAO.insert(qid, tid);
                    continue;
                }
            
                String query = "INSERT INTO " + TABLE + "(name) values(?)";
                PreparedStatement ps = connection.prepareStatement(query);
                ps.setString(1, name);
                int res = ps.executeUpdate();
                
                if (res > 0) {
                    tid = this.getLastInsertId();
                    QuestionsTagDAO questionTagDAO = new 
                        QuestionsTagDAO(connection);
                    questionTagDAO.insert(qid, tid);
                } 
            } catch(SQLException e) {
                System.out.println("Insertion error for " + name);
            }
        }
    }
    
    /**
     * Get all tags from database
     * @return
     * @throws SQLException 
     */
    public List<Tag> getTags()throws SQLException {
        List<Tag> tags = new ArrayList<>();
        String query = "SELECT * FROM " + TABLE;
        PreparedStatement ps = connection.prepareStatement(query);
        ResultSet rst = ps.executeQuery();
        
        while(rst.next()) {
            Tag tag = new Tag(rst.getInt("id"), rst.getString("name"));
            tags.add(tag);
        }
        
        return tags;
    }
    
    public int getIdByTag(String tag)throws SQLException {
        String query = "SELECT id FROM " + TABLE + " WHERE name=?";
        PreparedStatement ps = connection.prepareStatement(query);
        ps.setString(1, tag);
        ResultSet rst = ps.executeQuery();
        if (rst.next()) {
            return rst.getInt("id");
        }
        return -99;
    }
    
    /**
     * Get the id of the last row inserted
     * @return
     * @throws SQLException 
     */
    public int getLastInsertId()throws SQLException {
        String query = "SELECT MAX(id) AS id FROM " + TABLE;
        PreparedStatement ps = connection.prepareStatement(query);
        ResultSet rst = ps.executeQuery();
        rst.next();
        return rst.getInt("id");
    }
}
